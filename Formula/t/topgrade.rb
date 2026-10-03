class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.12.3.tar.gz"
  sha256 "2b7ec71fb11aa5d5db6e8b7fc492c28260835b1b64174923edae6cb38c50c4e6"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11ce37a4e90f98f753d150e161e1ec839b4f87a04b2ae2cf29b95cca6bc73b47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa91a9a75d013258952d7441549838c60e99e9937987806036b20a9ccb4bd41b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "157457285fc545854b77103522cfdf068f115a06e443ff61fbe30546f1125111"
    sha256 cellar: :any,                 arm64_linux:       "25f0ece5ca1d3b7922a707c1827f9a514ebbe926f13f68dbd88bdda261ac819c"
    sha256 cellar: :any,                 x86_64_linux:      "a2ab46a14583f3d722dcb819675b2e595e382d55e6228991a8e1752a09ba37ee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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