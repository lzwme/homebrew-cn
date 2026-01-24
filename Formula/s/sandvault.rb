class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "503ce93cb7e92c66c76b5ac8bd615b75eb16dbb09b7184e2c3b7305bd2d7156d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d490df37f44650ebb58bc40bb90d88cc3eebaaff34bd2e75585f70d91b1bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d490df37f44650ebb58bc40bb90d88cc3eebaaff34bd2e75585f70d91b1bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d490df37f44650ebb58bc40bb90d88cc3eebaaff34bd2e75585f70d91b1bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc5457514322df2dbec769fb33c4f616c8bb0dc32f5f1b78d9d262e718252fa"
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