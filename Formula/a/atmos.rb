class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.153.0.tar.gz"
  sha256 "e54a25bf85dd1e4a53718c3cb95bc935f9cd589535121f29772823c4671b16c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be55e8593836973db09678f8003f73ad770259e1d32e20de6dd823e0f802bde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be55e8593836973db09678f8003f73ad770259e1d32e20de6dd823e0f802bde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0be55e8593836973db09678f8003f73ad770259e1d32e20de6dd823e0f802bde"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3a18fdc3e2c65bf65345c644ac47f9d43d770c1f46363843ffa53ecf6648b9"
    sha256 cellar: :any_skip_relocation, ventura:       "ac3a18fdc3e2c65bf65345c644ac47f9d43d770c1f46363843ffa53ecf6648b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9dfcbfb3bab2a9d71755e3c4dcce646900241413addb56919c30c937f83075"
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