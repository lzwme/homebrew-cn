class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.69.0.tar.gz"
  sha256 "4e3a98e9affa6d43a9d4a8ae8c40f22a9abe48c20c3449adb9a809d7cbafde97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c326f42fce6fd3c4be9b901c58dfb1334e78e89b2e503e507031c27f237fc7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8abb06d5aff6a24821e7b901e81c3f34ed677fe3b350b28e8744e0d72b1b7f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d1bf46bde9a2f749f6348ef010d4b80aec03abde5f2ad8f4d6c1b798cf6c70"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b59ad9669199a8531e95070bccadfd09095f94312471d9f60cf3a614fedcaf4"
    sha256 cellar: :any_skip_relocation, ventura:        "2241a666628351edd62ae006511c01392eb43d2548f17b4d03f5ba9991dc944d"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe7881d4a88fec7da50c9f5f8bc97151c7b9f08223b6826e5b8da7449d7a971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd3370835b3e61ff2a4810ae9834317f20cf2a8be186ad334d3794036df4561"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.comcloudposseatmoscmd.Version=#{version}'")

    generate_completions_from_executable(bin"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath"atmos.yaml").write <<~EOT
      components:
        terraform:
          base_path: ".componentsterraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: ".componentshelmfile"
          kubeconfig_path: "devshm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: ".stacks"
        included_paths:
          - "***"
        excluded_paths:
          - "globals***"
          - "catalog***"
          - "***globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    EOT

    # create scaffold
    mkdir_p testpath"stacks"
    mkdir_p testpath"componentsterraformtop-level-component1"
    (testpath"stackstenant1-ue2-dev.yaml").write <<~EOT
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    EOT

    # create expected file
    (testpath"backend.tf.json").write <<~EOT
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    EOT

    system bin"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath"componentsterraformtop-level-component1backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end