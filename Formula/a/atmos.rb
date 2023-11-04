class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "f06ef16e319fe270d809b58c4652ab6cb30b4bf8afbacbe38a814b6b875a90d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dbecdfc00db798f64a6219788deb2d6cc1268f48ef017813b101a334cbec4c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b22255adcf23df5347860e8e953505f1edde0ca07f89f5811f77aece1a8636c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55dab4cf0bbd84c6f1a7206abecdc3c6c0868b3316ec69a8dbed737a0b7c16a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b928aa833bfe66150bb93b44a8f5812a45cdfcd17995062bad7cbe85a50ef071"
    sha256 cellar: :any_skip_relocation, ventura:        "8c81fbe0a2ca519619ff4827cc95ca1de9503ebae597e1a1d1c4d4fa5db57892"
    sha256 cellar: :any_skip_relocation, monterey:       "7b67cd266edfe942a79ff2617a74768d83ada25e0bc52a9e59217dc186cb58ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab05b5aea46971569689e89f92e7bc626a48fe9490a4ac7a0f54313a53e50f9"
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