class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "fae40a95cbab0d31efcfe81a014ab5ced91d254539ebcecb41beec064a3ac625"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "732e982d64b58b99efe543a9f72b546c99283424b76d8c725ffd8722d751097d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "732e982d64b58b99efe543a9f72b546c99283424b76d8c725ffd8722d751097d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "732e982d64b58b99efe543a9f72b546c99283424b76d8c725ffd8722d751097d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e4d194df25f08535b1a61a11acba25dfe700dcdb69a6ef9fdbcb4951613cdf5"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end