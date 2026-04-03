class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.2.1.tar.gz"
  sha256 "f8a0868885a75b3591ab7d77f2e1d7d9a0178331ae058f613dac219bf47e03e6"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "249de0ea689c658fc06602c0c8072e61ae3374f96c16bb4ca884196c0ac02174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f253ea20382ce74b7b5439c36fedfed0c4de74ce5eac10acdb29e3938a87564e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842b1f9122892dbde4191a010e275c15b34e506ba5c43746243ccd3867da1440"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f5261e145598ce3ea381073e3b2d09a1a8788f03073d846685eef156a183df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6179941355158448baabd7b9cefeb503a30e68e88654276d3b653a9911f6c6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb7a31caf7c3fd4262a46b5e8d459d4b614bc2033fdbb841a2c2c85422c5b96"
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