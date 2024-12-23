class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.15.0.tar.gz"
  sha256 "d0cafe61d27b5e3fcb53658821bfbf744fd040a8ea28b0e22277e032b8e8f7fe"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e938bf6752dc1494717a8354a3cd295b7b747202d23573a6a74a10bb0bfe3d4"
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completionsasdf.bash"
    fish_completion.install "completionsasdf.fish"
    zsh_completion.install "completions_asdf"
    libexec.install Dir["*"]

    bin.write_exec_script libexec"binasdf"
  end

  def caveats
    <<~EOS
      To use asdf, add the following line (or equivalent) to your shell profile
      e.g. ~.profile or ~.zshrc:
        . #{opt_libexec}asdf.sh
      e.g. ~.configfishconfig.fish
        source #{opt_libexec}asdf.fish
      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    output = shell_output("#{bin}asdf plugin-list 2>&1")
    assert_match "No plugins installed", output
  end
end