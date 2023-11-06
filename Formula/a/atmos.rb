class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://github.com/cloudposse/atmos"
  url "https://ghproxy.com/https://github.com/cloudposse/atmos/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "8f0ae42c1c6ef99e1b9769f46fe90fbdd27e0fb79c98d2152c3f23ac2856002e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad2ee1ff45a5ff4d3341e4a260fe10051a727b0392dda5a94aa5281364a8bfb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad8b862615666eb16b6fd02355abfd85bc1f12da046dc11fd7c73d3b9800dd1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b929846b19a8ea895370710391d93700f79d64ed57fa169e8582320c7f8d2f8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f88ac6d0021acb1a0b87af5072d4ac8da0c52250706a88cb9cbffaf936a3088a"
    sha256 cellar: :any_skip_relocation, ventura:        "80234bc951383f4b17d02f2aafa8eb69e7d373329195e86ba681c00f1590af01"
    sha256 cellar: :any_skip_relocation, monterey:       "eb4c8718b28ada1afdf8161fd60ec3b6919f45241316fa461b50b0aba2403cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1259cc3bbc6e3f47e0ea0b1f6b986b2e8d3d56c6080b081c8f63b89ed993b805"
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