class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.266.1.tar.gz"
  sha256 "4cc45d4298668da9598ba5d861822ded86882d557e65dabb9c6771208dec7709"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a2bf8b8289657b87012f2ac883465df6d37f24519b92b2f0a80ef25ed71bb07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab98d1e2df6a2c0f0aa4d5d6931ccd7b6fc92ce4b7298a3f19d1a5fe74a00e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8f823d906a7e8963b7c731af28a38cba361b606b8e8dfe5c881e7e731864c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ed3e502a8e67e2b8830b3c58e7422ee9be5b7db9f4bcf5a6fd97a2f13a19d53"
    sha256 cellar: :any_skip_relocation, ventura:       "32781948c8ac1c88e96585ee121ee70943dd8764950c7c57a72df9dafd646c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664e651546225a66e57b6c7d806a49d93761df39f7407cf01b775d4865332c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85ead96ad535b0834062b426b477e36f6b320cfcc2ff53f40e6f99c2b82e475"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system bin"flow", "init", testpath
    (testpath"test.js").write <<~JS
      * @flow *
      var x: string = 123;
    JS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end