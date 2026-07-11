class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.7.0.tar.gz"
  sha256 "9a914671f80a1a21f247125d044ff4b18324293110a9257770856c992c2e5ca4"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a62d06cad4c57bbdb9fb507a3634b241cc5584250de1c0f5fe0cfe1bec8dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f681fccdda7f4b713d3d1a1c428fd2561b4a95063b82ef05383d21132420495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f2051fbe399f509ce06b45358f44ef9d2337769267f137218a84ae410862598"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb29e9d90d24cdd5cd1b3d4a6b0c517258fd86819a130ec9d4d42cc9849fdb0c"
    sha256 cellar: :any,                 arm64_linux:   "2a2fe538c1b601b301decf8032c013b0b9d8e2152907003758b612700169e74c"
    sha256 cellar: :any,                 x86_64_linux:  "b7bb600f277a4ab22a93fe306e646c7e1fbfacf940742ade9850279dd1574824"
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