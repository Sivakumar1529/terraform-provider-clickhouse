package datasource

import (
	"context"
	_ "embed"
	"fmt"

	"github.com/hashicorp/terraform-plugin-framework-validators/stringvalidator"
	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/datasource/schema"
	"github.com/hashicorp/terraform-plugin-framework/schema/validator"
	"github.com/hashicorp/terraform-plugin-framework/types"

	"github.com/smugantechamb/terraform-provider-clickhouse/pkg/internal/api"
)

//go:embed descriptions/api_key_id.md
var apiKeyIdDataSourceDescription string

// Ensure the implementation satisfies the desired interfaces.
var _ datasource.DataSource = &apiKeyIdDataSource{}

// NewApiKeyIDDataSource is a helper function to simplify the provider implementation.
func NewApiKeyIDDataSource() datasource.DataSource {
	return &apiKeyIdDataSource{}
}

type apiKeyIdDataSource struct {
	client api.Client
}

func (d *apiKeyIdDataSource) Configure(ctx context.Context, req datasource.ConfigureRequest, resp *datasource.ConfigureResponse) {
	// Access DataSourceData from the provider configuration
	if req.ProviderData == nil {
		return
	}
	d.client = req.ProviderData.(api.Client)
}

func (d *apiKeyIdDataSource) Metadata(ctx context.Context, req datasource.MetadataRequest, resp *datasource.MetadataResponse) {
	resp.TypeName = "clickhouse_api_key_id"
}

type apiKeyIdDataSourceModel struct {
	Id   types.String `tfsdk:"id"`
	Name types.String `tfsdk:"name"`
}

func (d *apiKeyIdDataSource) Schema(ctx context.Context, req datasource.SchemaRequest, resp *datasource.SchemaResponse) {
	resp.Schema = schema.Schema{
		Attributes: map[string]schema.Attribute{
			"id": schema.StringAttribute{
				Description: "The ID of the API key used by the provider to connect to the service. This is a read-only attribute.",
				Computed:    true,
			},
			"name": schema.StringAttribute{
				Optional:    true,
				Computed:    true,
				Description: "The name of the API key to retrieve information about. If left empty, the API key used by the Terraform provider is used instead.",
				Validators: []validator.String{
					stringvalidator.LengthAtLeast(1),
				},
			},
		},
		MarkdownDescription: apiKeyIdDataSourceDescription,
	}
}

func (d *apiKeyIdDataSource) Read(ctx context.Context, req datasource.ReadRequest, resp *datasource.ReadResponse) {
	var data apiKeyIdDataSourceModel
	// Read Terraform configuration data into the model
	resp.Diagnostics.Append(req.Config.Get(ctx, &data)...)

	var name *string
	if !data.Name.IsNull() && !data.Name.IsUnknown() {
		name = data.Name.ValueStringPointer()
	}

	// Make the API request to get the apiKeyID
	apiKeyId, err := d.client.GetApiKeyID(ctx, name)
	if err != nil {
		resp.Diagnostics.AddError("failed get", fmt.Sprintf("error getting ID of the API key: %v", err))
		return
	}
	data.Id = types.StringValue(apiKeyId.ID)
	data.Name = types.StringValue(apiKeyId.Name)

	// Save data into Terraform state
	resp.Diagnostics.Append(resp.State.Set(ctx, &data)...)
}
