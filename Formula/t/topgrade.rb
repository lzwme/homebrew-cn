class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.14.0.tar.gz"
  sha256 "3f7580a52af5c11d7f51002c1b0d3153c52812f5ddcc53ab5d83417ae34cf552"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2402c198b9901ab39cdeba901efe2eaa2ce0b30174e77033d79ad02163c97a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7486a535804491631cb8882a700b365804e4e549ddeb82da8a3f44d03676b8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "089dc3cff1a44155f1a678bfc0f82623e232f0c714b896528f531ebb190e1fc8"
    sha256 cellar: :any,                 arm64_linux:       "ea8a39a50f0f0e8abd6f44f97f2fd483f4fc1e01230f7d93ff6cc2e8c43a83d1"
    sha256 cellar: :any,                 x86_64_linux:      "0beb10b33331c47d8ce346e50b9ada9ffe56387ec3816d49dbedc7aae0200b13"
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