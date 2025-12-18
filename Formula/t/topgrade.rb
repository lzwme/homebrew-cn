class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.7.0.tar.gz"
  sha256 "351a1f1a1676662aa00ad6440e7b493ae40fd40dd609cbe8b3920df981835aae"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76101129f3ff40d017b49dd64bdbb65ac743f61e5c05c2276606b43fd6feeb6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9034d80109aa4063d06aa5da839d8f27ca8b5d893e060709c20299214b2872cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4122effc62f5246e7f75e0e2403d25e06dc0b0feac8443812d4bd636c092d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e29945e20c7372aacd9a9a15f51589128c3bec8639cb3addf0d5323f51bfe7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d45ac7d35d0e6d15903ea1bccbf3f1618c575b81d3b7bdd8fbd3f468884a86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e649d792fd39f102fb156d3a06125ab7e0db65476c2b6ab4fac2e5b8fdff44ca"
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