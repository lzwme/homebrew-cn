class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://ghfast.top/https://github.com/timvisee/prs/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "52c8985911ae94d55bb84b005b1f7d7df9a291b74bc22638530766a3cf544580"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65811791381993bd346caf446b5073bf65a225265efc8dea880b3cbfeb2a4cd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c47cd6f196652f8b23b875ae86ba4455b156f9702290d697073caccfef829f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "621ea15eecbd92ddda26b25ee228ff4c7408b4873e1880fd093b5c7d43f64330"
    sha256 cellar: :any,                 arm64_linux:   "ab9fb359d4b0076efa9fec3420190f85ca80e04d93ae7c08157fccb07acc292f"
    sha256 cellar: :any,                 x86_64_linux:  "98b6af19f6d60862c6ec75c37ffa09764b6d223fd84ba7490f55255e2ea4a018"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"

    assert_match "prs recipients generate", shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_match version.to_s, shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end