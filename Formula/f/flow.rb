class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.220.0.tar.gz"
  sha256 "c8862c88360be693ead08cc4a212598a47a1fde762a00de27c03f47daec49cf4"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26ca454bb9a454c6588c5fbb54d158f8853afc618186ad289b3c3d41bd8635b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51fcfcb88a8dfdb28bd5bb6fedd243fa6a54a67cdd277aac84d6619688d8d45e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e34ad890a9ed691a07fe2ba1a85824195dae58076261fb063c2f708b866b51"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6b6d8ef774e643273ba363002fe1903eb960ff173e44fa7a43864e9c93d56cf"
    sha256 cellar: :any_skip_relocation, ventura:        "9d56a9073377ab5ecb276af528b8eb0b2023b0210737675ab941623097bed7c0"
    sha256 cellar: :any_skip_relocation, monterey:       "33b4f049eb9928db12ac0ce8862618bcd8affefbcbb045371be0604f874a27a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd75370121a6a7a86c023f1673ca2ef60ea2d27cca76e5cb1fa834f282e7d7e"
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