class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://ghfast.top/https://github.com/dependabot/cli/archive/refs/tags/v1.83.0.tar.gz"
  sha256 "c91e19517fca637167706a0b3a6ad0a36067139337c2212ce562507ede950053"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f41dee49af3d301b1888c08f3df17b0ade3936a4f813a7213fbc9ecaa1ba5e1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f41dee49af3d301b1888c08f3df17b0ade3936a4f813a7213fbc9ecaa1ba5e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41dee49af3d301b1888c08f3df17b0ade3936a4f813a7213fbc9ecaa1ba5e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e50853f9657ad0660a1433d5fd69690ded7149a12f5b4aefe8c1a034a08c63e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9820d994952b430a52f16d73958167a91b5cb54cc971fc36eb7c2078889e25e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8298e95bd1975b32e5518394ba88da52b9d039c84c32e818a0b04d7e9be031cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end