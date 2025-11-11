class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.2.1.tar.gz"
  sha256 "a457ed0be9bb5e598a1e8d9d5c9991466930ecf455dd14a234bf83a7126bc5e4"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13fe356460879e6f8e1d52ec8ff377ea15a51a157c982a1988c5903b09ffe67d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d700d7917456a5128490597f283055607fd7a3dedcc94e2685357b049dfa8217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08426a17371a7b21b0932186c2b94f5df605d5a7ffde0ffdc5d7878af37fa3a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "971bc4df6397bc282cb4c7f86588f9a03af93620b7c1d680f8a9769f05c4a340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca96d0c104d801f0d21aec413496a132cd9449256f2c1348bde5c9a2596a0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f5755f7b4d2faadb39243eb4dc711a8e3176bae5a308eb62511ea2abcdb1ac9"
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