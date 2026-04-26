class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "df41954393ea58a917680c0bffdce7c13295c8c90d06ced678fdc3df62195778"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1c6746bf983db58f21b72c64f8c9888b87691268b44817b29c6a3ecd257dd19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c6746bf983db58f21b72c64f8c9888b87691268b44817b29c6a3ecd257dd19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c6746bf983db58f21b72c64f8c9888b87691268b44817b29c6a3ecd257dd19"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c2c4fc165a4b74900108c31f607fe935bd98b50d54b1bd5f901c688b71738c8"
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