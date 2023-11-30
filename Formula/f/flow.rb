class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.223.0.tar.gz"
  sha256 "8d6f850db84097651919c5d047cadf8b13d294d7536c4387ad9841216984f68e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95c720690a416d1c8264b4237b7ccaba72e9a9eb8f9e4f43bddc61c8a7a6d4ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21885233c427b645d70ace582a5e2c7b0243c839096150c7eaa09902921f2f57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19131f7e955747fff4f5ad91f3281f150cd82ab7e88e877238d64fe8c16d107"
    sha256 cellar: :any_skip_relocation, sonoma:         "440c4eef419d60db29b00d83a2f67fc243b390abab915b69aa997f8af8c0aa13"
    sha256 cellar: :any_skip_relocation, ventura:        "8c1f1581037dfd14e5a40b0ad321642ea851abcc57ff48beb405af84bad616f0"
    sha256 cellar: :any_skip_relocation, monterey:       "946e6daa25b54752d595b6e06ccc1fe3fc476bd4d6a7222d3b3881b995b6903c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b803561ffd58303aa3d1588401839d2969eaec7922094b5668866b095cd9b0d6"
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