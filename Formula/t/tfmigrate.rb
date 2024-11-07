class Tfmigrate < Formula
  desc "TerraformOpenTofu state migration tool for GitOps"
  homepage "https:github.comminamijoyotfmigrate"
  url "https:github.comminamijoyotfmigratearchiverefstagsv0.3.25.tar.gz"
  sha256 "fabdf317d74eb090aad1230b496a9d8d6dac44ba222487b06a52a53224c6322c"
  license "MIT"
  head "https:github.comminamijoyotfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6d3dcb793b410ef9e99b5013e5b81e2d14fced42c7b57ea6f9c57642203501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6d3dcb793b410ef9e99b5013e5b81e2d14fced42c7b57ea6f9c57642203501"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d6d3dcb793b410ef9e99b5013e5b81e2d14fced42c7b57ea6f9c57642203501"
    sha256 cellar: :any_skip_relocation, sonoma:        "c282c78b4c4dd8253aa671cd478cee9564484a729c32352a3715fbc93751b189"
    sha256 cellar: :any_skip_relocation, ventura:       "c282c78b4c4dd8253aa671cd478cee9564484a729c32352a3715fbc93751b189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3760f796baa9c589bd22888111460da57700522bd12ab13c8d2cefe6d036345d"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin"tfmigrate --version")
  end
end