class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/v1.42.0.tar.gz"
  sha256 "54f1023702f344634dede897be1afb47589f02264295195dff59741dde128035"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d2c4c66a2339aef356a03ff2f6decbfa3f893fd4c9d5dace54462a54747e7c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d2c4c66a2339aef356a03ff2f6decbfa3f893fd4c9d5dace54462a54747e7c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d2c4c66a2339aef356a03ff2f6decbfa3f893fd4c9d5dace54462a54747e7c5"
    sha256 cellar: :any_skip_relocation, ventura:        "8ffd1566503a41a3307a37cb3f0039afe04aa0a3e9d5d584bf30e6c18b9f97b3"
    sha256 cellar: :any_skip_relocation, monterey:       "8ffd1566503a41a3307a37cb3f0039afe04aa0a3e9d5d584bf30e6c18b9f97b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ffd1566503a41a3307a37cb3f0039afe04aa0a3e9d5d584bf30e6c18b9f97b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "598af102ec417caae23a9935ef591073abe9c18c7f9e735be78209de9bebf570"
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