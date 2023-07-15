class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/v1.41.0.tar.gz"
  sha256 "95ee19c62f10bf83ed2caefbddda44baabf54c659e799003fbaf400521b76a24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a3a1be5c7ae8b3f5a216a4a25713e2a4f810e1a9ec47ae2985b8377e3ee584f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3a1be5c7ae8b3f5a216a4a25713e2a4f810e1a9ec47ae2985b8377e3ee584f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3a1be5c7ae8b3f5a216a4a25713e2a4f810e1a9ec47ae2985b8377e3ee584f"
    sha256 cellar: :any_skip_relocation, ventura:        "622098e8fc94fda5ee06803f8f4955426b9083147f1588eb2ebedd16ea7dd6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "622098e8fc94fda5ee06803f8f4955426b9083147f1588eb2ebedd16ea7dd6d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "622098e8fc94fda5ee06803f8f4955426b9083147f1588eb2ebedd16ea7dd6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa70c9dacbbfd1cd7fd53ccfd806479d2f7122f4ff01995fdf7a0058c26c842"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/cloudposse/atmos/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~EOT
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    EOT

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~EOT
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
    (testpath/"backend.tf.json").write <<~EOT
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

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end