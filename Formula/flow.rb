class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.213.1.tar.gz"
  sha256 "9fe023dc4c1df9308609ebdbd48aaabe39ca9fdfee2bbcde07e7d110d91f0e72"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d22d77269a52c9908317ddd11f5577fd11f90a19f5bb5d7dbb7d5276e70b1f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58521ba029a40a93dd28282b0e4d096a9bb4c2e5b7d778fefcc636cb78c2f893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b120728edefd5967952ec25e3c53604f8d20a86ad153abf5fc27ac40af4f8842"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6fc4be77c2fe6b8a44fd54e04b03988eb3edef0ccaaf92e51f3dbf99327bea"
    sha256 cellar: :any_skip_relocation, monterey:       "94ccdc356be09645b7757bfae6c7ff78f52132b7b55c47d5245093d6b280ac7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f3f1e068d1d8b2d21bb4be3012bdc4d01a286cf1ec4d1701440d4f2ec74b9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8e324bfebdc152906d737341159ed35835c108c05c1dead6b28730555c7a0b"
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