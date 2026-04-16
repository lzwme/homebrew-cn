class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://ghfast.top/https://github.com/webcoyote/sandvault/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "765290d912213a97ef81aadcdf6dab07dd84634a7b361726bf363bdf5cac2dc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e0c2e33e09c22e9e3fcc05594238601318fad510c41c77ea4f9ad59ebbc6c77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0c2e33e09c22e9e3fcc05594238601318fad510c41c77ea4f9ad59ebbc6c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0c2e33e09c22e9e3fcc05594238601318fad510c41c77ea4f9ad59ebbc6c77"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff66b5a9721980daf51c9bcb098333ac2916204bfc083b022a346c2b410b7fa"
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