class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.278.0.tar.gz"
  sha256 "6bfa1673a61c4ab713a9b9daa99e7d97bc934ca196f812dc76d01ef5b610f132"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a85ed987837eee5d33e8e5536232d11b9d573aa8ba669c7e1d10bbf6333d2ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16f7d97e1ee5cace83427b7c50c2444da75b538318d4a2d54ab1f22f1941aa64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cab01a630f36896e2e649f89875728c91bedd587fe44cd026cd8d3615667f4c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81f2f7937c154054469a59f57f2bb2b7e49b0702e0bbae897adaa672e5e2e5c6"
    sha256 cellar: :any_skip_relocation, ventura:       "ee06c2ea18f8ce9b0544bef72a9291ad9b33f0e170d36810242dfa47814a7c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb8791f5fabf41e201b1b8c1b34c3ccbb2054b23c10b861a6cfdd5e0262376d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfecb766863d47fe6c48890a4356ebec0fe8614ba92987e00e5d1efa4979ae0e"
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