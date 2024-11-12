class Tfmigrate < Formula
  desc "TerraformOpenTofu state migration tool for GitOps"
  homepage "https:github.comminamijoyotfmigrate"
  url "https:github.comminamijoyotfmigratearchiverefstagsv0.4.0.tar.gz"
  sha256 "684e0e4013792fadc48cd5f6850c3600b415892b4ae72532eed89af92f5f24e7"
  license "MIT"
  head "https:github.comminamijoyotfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c8aef70323f0e93d8c6c246e298734372ad9e4938eb908a2c95d2be4ad526c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c8aef70323f0e93d8c6c246e298734372ad9e4938eb908a2c95d2be4ad526c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86c8aef70323f0e93d8c6c246e298734372ad9e4938eb908a2c95d2be4ad526c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a4258c71f83f7e71317f9d8b37adf9ada95f895787cd8b549bc96a5dd8e1ff"
    sha256 cellar: :any_skip_relocation, ventura:       "d4a4258c71f83f7e71317f9d8b37adf9ada95f895787cd8b549bc96a5dd8e1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bcec3395051020e91ade7d004fa2f8698e2d0cfc9d40fa7b8ac7b74538e634"
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