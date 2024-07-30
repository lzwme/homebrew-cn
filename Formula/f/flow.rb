class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.242.0.tar.gz"
  sha256 "092dad2f001fe59a9b1ca246eba3b8c36bd9d92cec59b274264e370e381acb3e"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df0d417aaf0bd32b375eba68c83885321ef127aa3fa5c0d4ca3642cafecfdbd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6008b8c8f99aa830dbd6284892d93fe5575fa296e9d7999ca789c36de5e9ee2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee93bb96e50d55d63dc9a18ced1bbcbe3f556322eb58044c3d1633ff0f07cc21"
    sha256 cellar: :any_skip_relocation, sonoma:         "06fcddf5597583c51f615a2e5df0fafad19e316ef2c79a782ac0cc127039adfd"
    sha256 cellar: :any_skip_relocation, ventura:        "583be419ee14ff6e0368bfcf86e0dfdeb338b382546cea3973e7f76a74d3d947"
    sha256 cellar: :any_skip_relocation, monterey:       "f2f2a92fedaf42de585522785f6a75a08bebb29cb4915453aedcdd0f854f744c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68159cfd26b87bdf36a3fb8c08c4263208dd657750b040aedccc186c8f9a5c7"
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
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end