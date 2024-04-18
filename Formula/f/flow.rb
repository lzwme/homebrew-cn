class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.234.0.tar.gz"
  sha256 "02197f01db84b3b7b3ca4c12353f2026e912cc82e56dba465b985e026a403661"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2ca7c231cf15a5f90557497d7cb0c7d006693646d7352ee5cc5d2368196474e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab5d01e1ec215b80687f1e0ecf9d3e9f68200bfbcb7c34fc23e4909a00af617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8695560e6d6ce56238552307ac12dde6272d99cdc722a9d8d94e861da284f5b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c69e320282cd016345b6fa763d8e3e7745a445994784ea3bbfdcd48c0337206f"
    sha256 cellar: :any_skip_relocation, ventura:        "1c085506c5019104ebb5bd194a89f258db30d05696a8be75b015c75950234b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c2e05e7ce5d365b0ce3af840a9ce8ed2b9f57e578b652437c8a9a2e52e5b5f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7366dab2518c6f687ae93b106c90898f58d3971b61c0ceb9cef6aab3d567bdce"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end