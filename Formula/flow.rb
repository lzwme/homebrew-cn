class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.209.1.tar.gz"
  sha256 "ec8fcd78cae2547e25a143eed33fde7faada601ba802add94383dec90ee70cc1"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15059d345f151725273abe795ffd1e63e7d461d2767c82386314bf6f407a86ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7bb21ead715a0eea0ff36c3968c699944fb7df8f4289e8b32ce2a560f5dd6a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "348f946df1b509bf92b66d8200dbc56d139ef1681bbb84aa503754f72dc4022c"
    sha256 cellar: :any_skip_relocation, ventura:        "15e14c4b847078c6a0f974b5a9b4d208a217913cbe065c2903d4413e20760019"
    sha256 cellar: :any_skip_relocation, monterey:       "2be87d25fd6dfcd18197f08a3caeed06e638bdc1cbf602b05eb317807af9c913"
    sha256 cellar: :any_skip_relocation, big_sur:        "4022dd74dbcfade8960384ce5e09db3282b36ad83549b9ad38e6a06e9456159e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeced734c86635a402b13978440cf264225a53fb12c2ba118c37c2ac2ecb8813"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end