class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.1.4.tar.gz"
  sha256 "32a3c74872b253f796291576d3dc790fba58b86eef1b9897bf5a3f4b5d54edc5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "93e2334d241c289b09e7566d75e2b992640c706a615cbe063f186b1c7070c113"
    sha256 cellar: :any, arm64_sequoia: "297c723a51b24e3a82c1ca85ee2090e30e6b7c40e889b98c7e6d4e8ac3e61ba2"
    sha256 cellar: :any, arm64_sonoma:  "640288eba678ea752037ec9c163630a88e54cb854c51c80522a01e665f39d1bf"
    sha256 cellar: :any, sonoma:        "f0803e0ff6c0fbe6ed9b7a54cdeb91f17421090dd07dc949913601c6da52ef36"
    sha256 cellar: :any, arm64_linux:   "cd011a44ae2bafa8e9e46ea5399fbd401178e12775b415546dacb392b8254123"
    sha256 cellar: :any, x86_64_linux:  "c97375712d49da73a2b298d672dbd5bddc8f699990cdf3cc2550d99330c65431"
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