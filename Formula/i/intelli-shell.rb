class IntelliShell < Formula
  desc "Like IntelliSense, but for shells"
  homepage "https://lasantosr.github.io/intelli-shell/"
  url "https://ghfast.top/https://github.com/lasantosr/intelli-shell/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "480e5b5cfca9af5365f327867db375100b595c44aded05dc419fd11d5110c93a"
  license "Apache-2.0"
  head "https://github.com/lasantosr/intelli-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40d0d958f0bd01dde9381fb178072d2c5108bdc99341511aa5fe57cf62e86714"
    sha256 cellar: :any, arm64_sequoia: "d5ab03946c7f1a15d62b9e3952b396d6adb796260cac1e6dabec04820688457a"
    sha256 cellar: :any, arm64_sonoma:  "7ba08dae7b7c7dbe159967df6bf9bc175bad3762c5eedee33568818e4e402658"
    sha256 cellar: :any, sonoma:        "fc0a68f12466193fead3bc463727e79866ca02178def5e5b7d902f384c2b0972"
    sha256 cellar: :any, arm64_linux:   "ad6b73a088624bd386b2c84dcda55011b4a0134fa10bf604f9169d1675d47837"
    sha256 cellar: :any, x86_64_linux:  "d656484db59c233599125e70da75ef0c521935537a015ec79162df8681a4819d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/intelli-shell --version")

    system bin/"intelli-shell", "config", "--path"

    output = shell_output("#{bin}/intelli-shell export 2>&1", 1)
    assert_match "[Error] No commands or completions to export", output
  end
end