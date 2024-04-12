class Tfmigrate < Formula
  desc "TerraformOpenTofu state migration tool for GitOps"
  homepage "https:github.comminamijoyotfmigrate"
  url "https:github.comminamijoyotfmigratearchiverefstagsv0.3.21.tar.gz"
  sha256 "322feebbea60f3a616dba4f29e72428726858c945681ce2be6be488fcb35d9a3"
  license "MIT"
  head "https:github.comminamijoyotfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01eddc0128d14bfa102aae99a3a02d2fba6a36822bd404bb8024298ad1bf4e18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3adce5cc053af11ac36239786daf8604ddcd68e8f56f80b0beddeee84191b82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f23605404f5a24ae4e50f9e003dfd96f264888989f3d147f26d424a18f332f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bced2e451de02146e68c976050468d49935c2bd23fb7e1535dc76bcbe0b7586"
    sha256 cellar: :any_skip_relocation, ventura:        "6fbfd2a5be8fc57cf3982182a5c226392b686b72ee2c6a4a03ebe169c1b73dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "6f38c88d2bd5f79e30d13b5a165296350716f5e22935bcb49f17aa08e2dfa760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8544f0a5c63df1af1ea0bd7cff1a6c5dab48c15359c5a21e178ec5d84e4ae39"
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