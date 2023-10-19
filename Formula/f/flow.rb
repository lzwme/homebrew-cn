class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.219.0.tar.gz"
  sha256 "e1324a42a52cf010730d2b9773e000949703186a7975ab93999e9c011391c753"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c8c4ae8da30a360add5db058495ca3d0133241f835e03a29de6507df8bbb9b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e260474b983e3116756f20e61900de3f594cec642284aaeb151da6376a0896d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7207a34557b3e1bc03a892887a0df30142f2f8a0bd5679e69c851f95e433d44f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad406b61c319d949c2f89bf05877a503b11bc0264b470164fdf0d1a714305c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ab233dbb9dfab65ac20b8e1d5f22b01c6f79a9a77780eecb75096a038b06bac3"
    sha256 cellar: :any_skip_relocation, monterey:       "c04cf98d84cfc7068e6109daeca137dd560f1bd79b2d665568093dd79bcd73ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c63e58b8fec6cf873abb10cfd38ded9fb80b5bf3e30ec954b0ca7a1f4b98a8f"
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