class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "32631f7c27fdf9857b8c93f111984f4782024af25bf7981bbab4e7c173bc170b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8f727b9016a72b74bfc5af8cda423db7b89e5a76317f74578ba7300b4e870a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f727b9016a72b74bfc5af8cda423db7b89e5a76317f74578ba7300b4e870a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f727b9016a72b74bfc5af8cda423db7b89e5a76317f74578ba7300b4e870a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe276584093304c17eb5f7a46955775143ab0fb2113f3561ab6e9cd56c2f534"
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