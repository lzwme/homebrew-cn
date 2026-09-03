class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://ghfast.top/https://github.com/joshmedeski/sesh/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "7e163e3c8250d80db858827d1db8e35f0c63f7d9c0b947bf41026cc5819ccd34"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dcfd354072f19ea88843c9ce223ad19b285a338edbaf5f5f977c3abb1f5c61b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcfd354072f19ea88843c9ce223ad19b285a338edbaf5f5f977c3abb1f5c61b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcfd354072f19ea88843c9ce223ad19b285a338edbaf5f5f977c3abb1f5c61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2ea3ab1e2311a52bd585c77be3956ef20bcd99a0fc090e73cec71cb4468fb6a"
    sha256 cellar: :any,                 x86_64_linux:  "c5cb0564bbde59a395d014afd949f0c635a74a7d0a0bf7cbe4d46ab392996e4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end