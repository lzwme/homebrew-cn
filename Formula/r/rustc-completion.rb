class RustcCompletion < Formula
  desc "Bash completion for rustc"
  homepage "https:github.comroshanrust-bash-completion"
  license "MIT"
  head "https:github.comroshanrust-bash-completion.git", branch: "master"

  stable do
    url "https:github.comroshanrust-bash-completionarchiverefstags0.12.1.tar.gz"
    sha256 "562f84ccab40f2b3e7ef47e2e6d9b6615070a0e7330d64ea5368b6ad75455012"

    # upstream commit to fix an undefined command when sourcing the file directly
    patch do
      url "https:github.comroshanrust-bash-completioncommit932e9bb4e9f28c2785de2b8db6f0e8c050f4f9be.patch?full_index=1"
      sha256 "3da76d5469e7fa4579937d107a2661f740d704ac100442f37310aa6430f171a2"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "25c56cce81d2dbed3850ae8bcfc984a605ce5e734bacb82aefece825e896b9db"
  end

  def install
    bash_completion.install "etcbash_completion.drustc"
  end

  test do
    assert_match "-F _rustc",
      shell_output("bash -c 'source #{bash_completion}rustc && complete -p rustc'")
  end
end