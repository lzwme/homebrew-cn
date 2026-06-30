class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.2.1.tar.gz"
  sha256 "0e8c7dc6f886b683f1caed098861cbcb54c4a6956bfff6e066d557d552d4ed1e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b034a112885ed2d023be79e573538176a49c25d6adbdf8d668cdfdf29e19273e"
    sha256 cellar: :any, arm64_sequoia: "e3b1f748d15083c832fc759cd7515b5cc4df6908b9f4689b7ca6089e32dbb26a"
    sha256 cellar: :any, arm64_sonoma:  "a7c2ad68bb0f153e819c9bd2e6f828ca7cbf3d167e744a2c5ef44c5a3fff5f37"
    sha256 cellar: :any, sonoma:        "3a6ee46925a49e6db8267da1c4ed63ad68345ecb4e7f5901a02586d91e13f21c"
    sha256 cellar: :any, arm64_linux:   "15833fee55501f5fef78c30e47f07e8152f6ccc97b182adbb34649fbc7424b9a"
    sha256 cellar: :any, x86_64_linux:  "ceb2accc87e7635ba3b743b9edabe2b36430c956aabccb19edb8d8392444aaff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    assert_match "Error", shell_output("#{bin}/pass-cli login 2>&1", 1)
  end
end