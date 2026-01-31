class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.13.tar.gz"
  sha256 "6a323f7409c787e651c5102526a965bbc05865ac96b499e3c6b19d3297454b41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d70369fc0269681222cbbe1a2a6b799500e6e684005ce3e8e46f6dfc2d68dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d70369fc0269681222cbbe1a2a6b799500e6e684005ce3e8e46f6dfc2d68dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d70369fc0269681222cbbe1a2a6b799500e6e684005ce3e8e46f6dfc2d68dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9021f532efac0be8305ecbf37cbc95575d677d84712863a96a53c0c302feb8d7"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end