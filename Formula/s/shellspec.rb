class Shellspec < Formula
  desc "BDD unit testing framework for dash, bash, ksh, zsh and all POSIX shells"
  homepage "https:shellspec.info"
  url "https:github.comshellspecshellspecarchiverefstags0.28.1.tar.gz"
  sha256 "400d835466429a5fe6c77a62775a9173729d61dd43e05dfa893e8cf6cb511783"
  license "MIT"
  head "https:github.comshellspecshellspec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c39e6acfcb13b4e82fdaf4e2a2788c5b43eacd7be9d2f98d5d786d0e741befad"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin"shellspec", "--init"
    assert_match "--require spec_helper", (testpath".shellspec").read
    assert_predicate testpath"specspec_helper.sh", :exist?

    (testpath"specexample_spec.sh").write <<~SPEC
      Describe 'hello.sh'
        Include libhello.sh
        It 'says hello'
          When call hello ShellSpec
          The output should equal 'Hello ShellSpec!'
        End
      End
    SPEC

    (testpath"libhello.sh").write <<~SHELL
      hello() {
        echo "Hello ${1}!"
      }
    SHELL

    output = shell_output("#{bin}shellspec --shell sh 2>&1", 102)
    assert_match "1 example, 0 failures", output

    assert_match version.to_s, shell_output("#{bin}shellspec --version")
  end
end