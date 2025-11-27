class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.5.0.tar.gz"
  sha256 "a9ef518f34fc7ad2d6c1f1fb0400d2ee860da2ba2ca99bcfd506778d40a9b125"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad40b377b5a15cb0ba7286b9c60c87c17890a42ceecb37a6f11c8d4802947b41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad46e0127dddae246a0f1cd4c8bb946d64a06e832248e6298ab0d87788ac3d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7bc973fbff0411a0906cd4cc021e90dfb993cd67c41eba71b7b3ff7d04fe42b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d8e14591a5c23ce28182a3968cc518e7e381e76f11bce01b1f79c174c82ae2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b908140df74c906ed8f882c426825d09817c71ac3b9da6d39f66eb4d647766b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e8d879a5560c555cdf166cf01039da3f490d5fe57d1a0f3849eea5f8f60bc5f"
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