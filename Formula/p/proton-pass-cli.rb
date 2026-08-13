class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.3.1.tar.gz"
  sha256 "117f28e2d0e05f01c9ef296870a91a9ab4ac42f7b3e260818d556501e8e39055"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d14322557bfa5c87f415e69f432d00997bafa1ca63e3fec759b82be27be5bc92"
    sha256 cellar: :any, arm64_sequoia: "44dfec8b23b6f85a44c94648d81f8b3637cead4a9b87fed34afcc4216ef34355"
    sha256 cellar: :any, arm64_sonoma:  "380d197b2c6f4b5e8b74410504641ba3eab832083744fd5d7d93b42ecc82732a"
    sha256 cellar: :any, sonoma:        "3e77f57e14927b3d22535c99082a9e4950227b21173fba57c3cc3dd48de056a0"
    sha256 cellar: :any, arm64_linux:   "331b62d2b70aabafd086155cdccfefd9a87b65dfc6241d090f9299f839ccd5e7"
    sha256 cellar: :any, x86_64_linux:  "a941b36861231d6a3a5450ee67b0ff1dad572aadc7512057ab0ed4df0efc9b6d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end