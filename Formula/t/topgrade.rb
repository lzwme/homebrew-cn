class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.3.0.tar.gz"
  sha256 "16b89bd2ec145af01d505bb25f6d04ecc3945fa1a964db2bd9b63a7757a03232"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31fc9abbaf66b466e058a829db511be8835d3503fc3383f4b701d3d1bfa67158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be1632f8023e9368dccacadb770d0e6e7b9d0cd89557cf8c6402ee648de9738d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f36a96aabc76b410b7436d8f61dec1235658861e1a9315d854e12c11932f946"
    sha256 cellar: :any_skip_relocation, sonoma:        "c03b757c2aa37e9c8f1728851fb698b9ff7cef40d22aca471a8761a9cdba6caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae4b293d658704206810ede1354210fa09c8c0f9bd4b01ea0fc113eb68b74359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6908ff310d486e527140cf45bfd1910559ab6fd4b0781e5a24b62a4865465ba"
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