class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghproxy.com/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v12.0.1.tar.gz"
  sha256 "d8a9eeb9c6ae3aab8163b726e912fa7c39849c3ad9f1e39a07924885f639b7bf"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26c03a2236a9a88987530a7f17315b970c8a68f051a59436acf3de64f725cf6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe4d946a7952ad84b027d59b37b224f3a8cf260e36930ee9f919b1ee0ce9675"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbecfd8adea5ce4e0a9d31aab9cccff37ebbf7c667ba279e88dd3c7223e6fefc"
    sha256 cellar: :any_skip_relocation, ventura:        "4f0051ff5dd6dfeca80648210bed868dc12db4aa083e2854d46abe29c086db20"
    sha256 cellar: :any_skip_relocation, monterey:       "8aaa200e67e9434d2c689316ec8fe93e61742904e2bb6a003976a3f12e8675cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e93d8c1d0b0b444aaf6ce1138cf0ebf7229248a38078d2ff745f70c109c3c231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c214f2e3c4a2ae4ab0ab0c9b85c0554ae2ef07bf254bfdb00672038822a9c9e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end