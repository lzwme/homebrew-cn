class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.277.1.tar.gz"
  sha256 "d12ec82b6219ddee0d4bf64af5680a0b1865668457088c8e9eaa27eac75ab5a5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0172917f2a2a623773c62ec51127d879986c4a84b1c54c14fc59bc4f68d42994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24465967781d286e3814313c1bfaa83947d0e5b97c37c06afde3db16dfde2642"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7cb3433f5d0f7d1264e2b9152064a7b2a180bf87819ca11672dd1a704ed29bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d10e8aa306f5f8a348d667979eb136286463294a739535e0b9427835c94bfb7"
    sha256 cellar: :any_skip_relocation, ventura:       "0635837bca08e3e34344ef2714392fe8f3ce67069777026ac70d55627d113fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d23e7ed95241aff7d4e3be5f7818756afbde2529df6ab5e6c169ade16bc97b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d18e80a5a0dd92ff19740c244028debf9161ee8487a778909b4bbab02596bbfc"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end