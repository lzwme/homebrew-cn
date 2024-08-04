class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https:github.comnvm-shnvm"
  url "https:github.comnvm-shnvmarchiverefstagsv0.40.0.tar.gz"
  sha256 "653e969eb5dd49a43579257c7f7064703984b92f883394f8491a78a087b1285f"
  license "MIT"
  head "https:github.comnvm-shnvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af3f9692df19ac0f8599ea485d68a42b0af097227e4ec8684e2710f36d4443be"
  end

  def install
    (prefix"nvm.sh").write <<~EOS
      # $NVM_DIR should be "$HOME.nvm" by default to avoid user-installed nodes destroyed every update
      [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME.nvm"
      \\. #{libexec}nvm.sh
      # "nvm exec" and certain 3rd party scripts expect "nvm.sh" and "nvm-exec" to exist under $NVM_DIR
      [ -e "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
      [ -e "$NVM_DIRnvm.sh" ] || ln -s #{opt_libexec}nvm.sh "$NVM_DIRnvm.sh"
      [ -e "$NVM_DIRnvm-exec" ] || ln -s #{opt_libexec}nvm-exec "$NVM_DIRnvm-exec"
    EOS
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