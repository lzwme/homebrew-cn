class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.88.0.tar.gz"
  sha256 "c9258506be8a4349555fa08432a6bfbc0e4036eb865fa9b0f86fef6fa78aaf9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50c1f46a976f3b360f646fbe1f18d1e3ef31f137bd05ecb7c0aed3d5658ab8e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c1f46a976f3b360f646fbe1f18d1e3ef31f137bd05ecb7c0aed3d5658ab8e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50c1f46a976f3b360f646fbe1f18d1e3ef31f137bd05ecb7c0aed3d5658ab8e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4982fbc166b20faa93dc07f8d6e78f1ae73ce3f2c4e5cf5eb99af7c2ffcd967"
    sha256 cellar: :any_skip_relocation, ventura:        "d4982fbc166b20faa93dc07f8d6e78f1ae73ce3f2c4e5cf5eb99af7c2ffcd967"
    sha256 cellar: :any_skip_relocation, monterey:       "d4982fbc166b20faa93dc07f8d6e78f1ae73ce3f2c4e5cf5eb99af7c2ffcd967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86936ce56a6bc395ed074280ae26e6dc3c157ce3498206ceeed4b255b97657bb"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

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