class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https:github.comzsh-userszsh-completions"
  url "https:github.comzsh-userszsh-completionsarchiverefstags0.35.0.tar.gz"
  sha256 "811bb4213622720872e08d6e0857f1dd7bc12ff7aa2099a170b76301a53f4fbe"
  # The maindefault license is the same as Zsh (MIT-Modern-Variant); however,
  # the majority of completions are BSD-3-Clause. The remainder is mostly MIT.
  # A few completions use other licenses and are specifically noted below.
  license all_of: [
    "MIT-Modern-Variant",
    "BSD-3-Clause",
    "MIT",
    "Apache-2.0", # _cf, _hledger
    "ISC", # _rfkill
    "NCSA", # _include-what-you-use
  ]
  head "https:github.comzsh-userszsh-completions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a9005c599c91337f5d8689ae0f725f2d204f123dcd0aef68ee4279ba27eaf94"
  end

  uses_from_macos "zsh" => :test

  def install
    inreplace "src_ghc", "usrlocal", HOMEBREW_PREFIX
    # We install this into `pkgshare` to avoid conflicts
    # with completions installed by other formulae. See:
    #   https:github.comHomebrewhomebrew-corepull126586
    pkgshare.install Dir["src_*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        if type brew &>devnull; then
          FPATH=$(brew --prefix)sharezsh-completions:$FPATH

          autoload -Uz compinit
          compinit
        fi

      You may also need to force rebuild `zcompdump`:

        rm -f ~.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run these commands:

        chmod go-w '#{HOMEBREW_PREFIX}share'
        chmod -R go-w '#{HOMEBREW_PREFIX}sharezsh'
    EOS
  end

  test do
    (testpath"test.zsh").write <<~EOS
      fpath=(#{pkgshare} $fpath)
      autoload _ack
      which _ack
    EOS
    assert_match(^_ack, shell_output("zsh test.zsh"))
  end
end