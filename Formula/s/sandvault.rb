class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.25.tar.gz"
  sha256 "9e03dd6e06e9f5eab3ca95a6df2756db510de626f276508f37db6f04561d1671"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faaf9be7bb45bc2011c2ee7c50b9cb9095b5a78b13734fbe706af63dab65b1b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d2325ee073a4166c6643c60a9ceba7450fe35f27c0a74363eaeddff6f8713e"
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