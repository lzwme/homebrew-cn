class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.13.1.tar.gz"
  sha256 "bd41bb93050d16194568063f8fdb45d3d89f9d27fb6e58fb87991602b0288d87"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9fd201ad0f95bcd489302a9420ace7fa697d1b1af6b033ab5fa7b6185cfc8c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "857891b9ab6b9de6d239a304111ea5aadbc995bed12482d4d4661991dad69489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "637266737a97943537010d02d2dfc3b0b03fdfdb7931a94193957455310ed58a"
    sha256 cellar: :any,                 arm64_linux:       "2ecb7e1419659c84e1f06f901fa0a5cb16939c11068527acde331ccacefaa9a1"
    sha256 cellar: :any,                 x86_64_linux:      "642122b92cf30d93c66790f7e78c1e604a4eab3df358a43a523978e4dab43a47"
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