class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "92eb620a6679f21ca146fcf8e791bac2a6783f038e55db576964b620ae1deceb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4096af202ba616a89d3438eea97f889e91506ce3e735396654fa3bf641816c28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b97b3a4777432c58c6d6a740d1a3ee0e08fa27daec2649975f5eebe17ddc05b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50127356933128fbf45a269575bdf858bcc0abb7158710983189d853ffa47620"
    sha256 cellar: :any_skip_relocation, sonoma:         "437bb1cbe079959caed14d66d421a0a9c2078acedfb147a27e31046c946b61e0"
    sha256 cellar: :any_skip_relocation, ventura:        "b6240a74359f134ae353fbb832a28a0dc9a3d2461e19060cad4f888dde767f13"
    sha256 cellar: :any_skip_relocation, monterey:       "b4deb694ab74288a26aec38ca479a618261a68e1ae2fa6c5f8a963cf2ae754e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04015aa844e2f71b01a2cf5b9296c765d07d8564e6eda269ba306840550fa29b"
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