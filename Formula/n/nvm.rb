class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https:github.comnvm-shnvm"
  url "https:github.comnvm-shnvmarchiverefstagsv0.40.2.tar.gz"
  sha256 "da642dbff51d9afc729d67f8aa327decaf16e8b4efee792f0be2da817bd6760e"
  license "MIT"
  head "https:github.comnvm-shnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a44ae3088b3b8c785c86237c139a8c846cd90f1646eb3f828343171907e36e9"
  end

  def install
    (prefix"nvm.sh").write <<~SH
      # $NVM_DIR should be "$HOME.nvm" by default to avoid user-installed nodes destroyed every update
      [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME.nvm"
      \\. #{libexec}nvm.sh
      # "nvm exec" and certain 3rd party scripts expect "nvm.sh" and "nvm-exec" to exist under $NVM_DIR
      [ -e "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
      [ -e "$NVM_DIRnvm.sh" ] || ln -s #{opt_libexec}nvm.sh "$NVM_DIRnvm.sh"
      [ -e "$NVM_DIRnvm-exec" ] || ln -s #{opt_libexec}nvm-exec "$NVM_DIRnvm-exec"
    SH
    libexec.install "nvm.sh", "nvm-exec"
    prefix.install_symlink libexec"nvm-exec"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats
    <<~EOS
      Please note that upstream has asked us to make explicit managing
      nvm via Homebrew is unsupported by them and you should check any
      problems against the standard nvm install method prior to reporting.

      You should create NVM's working directory if it doesn't exist:
        mkdir ~.nvm

      Add the following to your shell profile e.g. ~.profile or ~.zshrc:
        export NVM_DIR="$HOME.nvm"
        [ -s "#{opt_prefix}nvm.sh" ] && \\. "#{opt_prefix}nvm.sh"  # This loads nvm
        [ -s "#{opt_prefix}etcbash_completion.dnvm" ] && \\. "#{opt_prefix}etcbash_completion.dnvm"  # This loads nvm bash_completion

      You can set $NVM_DIR to any location, but leaving it unchanged from
      #{prefix} will destroy any nvm-installed Node installations
      upon upgradereinstall.

      Type `nvm help` for further information.
    EOS
  end

  test do
    output = pipe_output("NODE_VERSION=homebrewtest #{prefix}nvm-exec 2>&1")
    refute_match(No such file or directory, output)
    refute_match(nvm: command not found, output)
    assert_match "NA: version \"homebrewtest\" is not yet installed", output
  end
end