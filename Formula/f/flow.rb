class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.289.0.tar.gz"
  sha256 "e80ab9459f600a3e8da4db71f45d84171178fd98c72b5f6357f215e65e262a5c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19d7651f21609bbee810cd400cc877bc0e2a91202e08f36400e77ca9261f4ad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7465f26961e5f8d60e01c9130f7510018e3dc70c4e6dc93f48f4bc43a9fed0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9703f56d0f03db1b593d3f1673c45a6e55f40c2339c7a95ae381b839507da8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d30b14600994b3f02bb3548cf485ab247754ac8fdbc6870577e46fe590ccdb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89666c5372bbf077d5c52bb75930b6e195f48a6ea1bf66397b6d7afbe7934b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bc49d534f16bf8dceb4479ae7b97ba47053940c44e45353112cb275ac08d925"
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