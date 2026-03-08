class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.0.0.tar.gz"
  sha256 "ca181851466182e905c485fafef56fd083d967c77c2f0c3eafa8fa5792feb55f"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9156d812ed413a267f5fbc9f4e6cc51a29d68f24d5c5487dfc5bb0b8c4b2e1b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee559571aca67bcfd290b55c5b87b2f42dc98b11846562b11d84e6ef4bc247a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00083ce66b1081d903d002228d142e462e6e56c0d0f1802c25c14a36233f3624"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ed3ef6ec12a7e13dcbde1973cb75a9f5e015d009da354c3bdb8613a9631b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab8ad2664217cee74b9bedcd7cf63cd422dd47ab3c0ca3b97e3e4ec60f6420de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7eb9e7b5633da82fcfabb4b290c9b861f13dbb387e9d5f5e8d987d8e3b9e7fb"
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