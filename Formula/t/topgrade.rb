class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.1.2.tar.gz"
  sha256 "58d1d8de281dbcb4fd2cee1e1e8b22deb5e5baf282c9518a3ddb2673bba07c88"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96dd09d80604a4052f1df24d239d9c3a884900106dfe05d0463b535c71d286f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0032bdc7a994892625b2bc08a29c618d88d5f7d21055ee903478042f16a45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f74666eb1aa2917bf450436eb69ad81a6867d595a07263d57cab28a151f86ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc6282b12ce7356ae4999bfe4f50242a951706cca571742a5fde045b0eed96e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec33b3bb467390043967b14276d86d4afc4d812b7d7e6d2653fe5890cff62d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e612c953fdae54c80cf4c16fb679f27e4e4261e63cf570139cc8a1d766c3065"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end