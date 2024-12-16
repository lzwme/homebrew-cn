class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.127.0.tar.gz"
  sha256 "caedd0776b8f6fa9d98ff2e418307b52b3a05957959e5893e748a2d033f6c39b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea78a330289e72b43aae8af482a0c9a0b829bae7ce40c75c4a3c922f97811260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea78a330289e72b43aae8af482a0c9a0b829bae7ce40c75c4a3c922f97811260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea78a330289e72b43aae8af482a0c9a0b829bae7ce40c75c4a3c922f97811260"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4a638faf451bd1339ef37ab0bee4461e2dac2c9fb7f319ce520193afe8d6c2"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4a638faf451bd1339ef37ab0bee4461e2dac2c9fb7f319ce520193afe8d6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a48e3d6a059754f39473d8297d99ce8d45db6a7181c6afe49f82b553deaadcc"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.comcloudposseatmospkgversion.Version=#{version}'")

    generate_completions_from_executable(bin"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath"atmos.yaml").write <<~YAML
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
    YAML

    # create scaffold
    mkdir_p testpath"stacks"
    mkdir_p testpath"componentsterraformtop-level-component1"
    (testpath"stackstenant1-ue2-dev.yaml").write <<~YAML
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
    YAML

    # create expected file
    (testpath"backend.tf.json").write <<~JSON
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
    JSON

    system bin"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath"componentsterraformtop-level-component1backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set

    assert_match "Atmos #{version}", shell_output("#{bin}atmos version")
  end
end