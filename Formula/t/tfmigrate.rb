class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://ghproxy.com/https://github.com/minamijoyo/tfmigrate/archive/v0.3.17.tar.gz"
  sha256 "23346c0214e2ce472a1a8397dd5bc8e503c5ee619dbb9a16750d59e8e8564391"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcd7c0538abe80fcc5096acce051af2e21e9fe3986ef8d7cd81529627b6a30a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dcd7c0538abe80fcc5096acce051af2e21e9fe3986ef8d7cd81529627b6a30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dcd7c0538abe80fcc5096acce051af2e21e9fe3986ef8d7cd81529627b6a30a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3223a3d046832f9b1d903aee1035f255694233ea78edeb543943122fb6147d41"
    sha256 cellar: :any_skip_relocation, ventura:        "3223a3d046832f9b1d903aee1035f255694233ea78edeb543943122fb6147d41"
    sha256 cellar: :any_skip_relocation, monterey:       "3223a3d046832f9b1d903aee1035f255694233ea78edeb543943122fb6147d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46eb125b055b5302f4bbdade9c40572accf80f830c14e691f4f22fdeb3fda68a"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end