class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.5.0.tar.gz"
  sha256 "4cf993e969df4e4726ff39d54c80e16a0e0710428801b8b84141122300109ff5"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec85176a144af44d3346dda1c19bf38ff74cb8efbd037ce12851a04b046b39e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc496e88361449b71225bfbc9fa17a482c703dd98275994c3a7d2eb044d5130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a920cb451ad5691832ce3284d52afc36abfff05138426bbd081c4666d04ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "405be1506fcbec3591d3e5e83c4abba2f7543c9c78e8aeaafbe2a15a0093c42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033fe8ef3f9cc743c85332afc74cab5052243b824d31a1ef27cd02f3899d5c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822da4519d172f2536dd95c13333c4bf727c5bb5f60eeb207cb0f1ef35a75284"
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