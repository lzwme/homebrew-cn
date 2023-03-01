class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://ghproxy.com/https://github.com/minamijoyo/tfmigrate/archive/v0.3.10.tar.gz"
  sha256 "8595bbce061943b6c16d63c4410944e99158e3dc460f88194a3c8f1b91222da9"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b074e71d4dbd28f29d0a3300b10a8bdb4835f858018913c5cd7ec3d23e200b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b074e71d4dbd28f29d0a3300b10a8bdb4835f858018913c5cd7ec3d23e200b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b074e71d4dbd28f29d0a3300b10a8bdb4835f858018913c5cd7ec3d23e200b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "d4649fa55727155cde94504487421d0d1683a6bd497b17efc6c137e881985ac8"
    sha256 cellar: :any_skip_relocation, monterey:       "d4649fa55727155cde94504487421d0d1683a6bd497b17efc6c137e881985ac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4649fa55727155cde94504487421d0d1683a6bd497b17efc6c137e881985ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9985019aa58c4ea4e40c00b2c903d8edb06ffc176a4cf8e79e00894044fe8a5d"
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