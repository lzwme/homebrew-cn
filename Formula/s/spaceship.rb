class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://ghfast.top/https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.20.0.tar.gz"
  sha256 "040444303c377eaeb1fc484985fbea87b811f7f10e4e03d87fa84e506a0d4539"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09b0998781d2d7bae5c326dadef8f5487d83694355ba23be643c1a1c692baf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6f0bee3b3de8425c8533d03be039564936900fe933efa99a0351163bf8f973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe2bd7a00556e996667c6424e57363a07386348396987da6983c67d8ecb8aa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d8be8f31fedcfe1854e75b2d3baa06490488c23daab4000d5fb7f7a98e23f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518957a2180747ae12166be5904b2f7b3d9782fdb70c3ea569465338ee4e7ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80c0e696be7e01a0229a4c7645e1ef9f1a62750cc686c6153231da548335fad"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end