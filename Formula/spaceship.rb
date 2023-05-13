class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://ghproxy.com/https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.13.5.tar.gz"
  sha256 "2820efc17a6df0346b1b8e5fafe04c9c4efe5971f30bbe7bf1298a50e5606b07"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "929572d25ce60407b634904ac85e31b99e7eacdfc0bcbc5ddd548c979614580c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948acf093d34defdf6bc95fcfe913b2497280163a0e3fdbc9e64d2e70587769b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285dcc50fca078a82bd0dbbf1022786352bc313025482a952a4b88d36234cf9e"
    sha256 cellar: :any_skip_relocation, ventura:        "47725874f4f0aa5bf785767110ac65d41a5b96e4b099004d47cd832a4010c42c"
    sha256 cellar: :any_skip_relocation, monterey:       "b09940a2f083385288666e57fb2ccd11610ac5458afc97084105b2118914ddc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ea9fda618ad416d97c022ad2cc635bd2fbde82239ea6c3cea9a1d701d115300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96322120d24e7e7c00531c2720b7f21ce05710aa539d0b2b9208417a015bb34"
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