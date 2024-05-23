class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https:liquidprompt.readthedocs.ioenstable"
  url "https:github.comliquidpromptliquidpromptarchiverefstagsv2.2.0.tar.gz"
  sha256 "8fcfd3a192f6f484cd29e0c5bea02564adf0ee524d6dfad52307ca9d54bffd15"
  license "AGPL-3.0-or-later"
  head "https:github.comliquidpromptliquidprompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86cd845ab88a095f82935451ac00eab94f197cd65a586bdff4914d31e8b8ba70"
  end

  def install
    share.install "liquidprompt"
  end

  def caveats
    <<~EOS
      Add the following lines to your bash or zsh config (e.g. ~.bash_profile):
        if [ -f #{HOMEBREW_PREFIX}shareliquidprompt ]; then
          . #{HOMEBREW_PREFIX}shareliquidprompt
        fi

      If you'd like to reconfigure options, you may do so in ~.liquidpromptrc.
    EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}shareliquidprompt"
    output = shell_output("binbash -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end