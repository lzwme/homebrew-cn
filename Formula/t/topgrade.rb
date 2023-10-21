class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghproxy.com/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "6d83af871b6ce108dd4773c81835734d306b41425c41c533095ca5a82324b049"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "420ebd0679aed63ca88c7b5517f31b648679b3eae25f8c9667d5ea2adce93483"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081243133015cebb27d53f521d93520146f534da493f1fec29c9780d3601f6a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb1477ce33fbd4310c989c19a1bc7427f26456eb1b6f1c09e04d1272aabe8560"
    sha256 cellar: :any_skip_relocation, sonoma:         "634bc2068940441f295f194512de26a8ad87bdff6ad55d5419a989410644aaea"
    sha256 cellar: :any_skip_relocation, ventura:        "585115c736d82d4144f66095db93a86ae715954fe87c88a59f98b0b6c8856668"
    sha256 cellar: :any_skip_relocation, monterey:       "16e5f63b04f2dac8fec521a97569f3e792e903e2e7865dcd4dbb0099bfce8351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199cd9900cddea4f2fffa622988b841d1ff492e00aad3d75fc7f699845ce1d7a"
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