class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/v1.36.0.tar.gz"
  sha256 "e79d262aef9d21d6b8e08ced3a114a6817ee8237a696c33fdccf03008f6e37da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dfb7fd48114da562b2492b087e4901eed1d8e8feb480f97963f36d282fe5051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dfb7fd48114da562b2492b087e4901eed1d8e8feb480f97963f36d282fe5051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dfb7fd48114da562b2492b087e4901eed1d8e8feb480f97963f36d282fe5051"
    sha256 cellar: :any_skip_relocation, ventura:        "9626cc6db6fe06a084f601b3b0d8a287c39f9d66326bc7fe95f55a238bd498bd"
    sha256 cellar: :any_skip_relocation, monterey:       "9626cc6db6fe06a084f601b3b0d8a287c39f9d66326bc7fe95f55a238bd498bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9626cc6db6fe06a084f601b3b0d8a287c39f9d66326bc7fe95f55a238bd498bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e20fe70989e6ac91ee12a4f5fb3ee48cc43bed69fab8e872de87285f639399"
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