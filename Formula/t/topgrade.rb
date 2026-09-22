class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.12.1.tar.gz"
  sha256 "12beb81a0405c049920148d58747cdc5d406a68825eb955a95ad9bc989bd38bc"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a16849e663b5b51368c09691006d24347bce0ac2562f05ee436d0a1753c78354"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bca40d75eb42c6f809456f22bc3380ffb38eafc02d1c601813acb8f37d6be5b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f7d44f1fbe77ab1092c396ad8994e0b45ea7b16e0966f24c42d72788fae1a27"
    sha256 cellar: :any,                 arm64_linux:       "a29ba839153bb1f8faabfca2ac19bb0b195ba0a7ab9d5102b92ef887334b2ca5"
    sha256 cellar: :any,                 x86_64_linux:      "813e594269e821d7da36ce2a28dc7e256ae2c993dde1a97c2c466b6f2b3f305f"
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