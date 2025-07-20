class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.276.0.tar.gz"
  sha256 "9ae4a9b7dea7bcc478803939b0774644e525bc14d371c8de42b6fb3f2a1b1314"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e77143f667be819d08e3799adf0f57656cf3b4081eb732d8a7820def563e550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ec07fa39fcfc5ae0bc50fd965e646c4744a82ab850f266c378914433f34a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cef0d2c62ab597eb74065ea77ca8e0e4107f561c265232e0cd2f9ab609eb135"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f32f39ed4623858b640eaf98ec30d16d70bf4810fade660eda79e8ee5fb916f"
    sha256 cellar: :any_skip_relocation, ventura:       "e38b2bac323dd372493f6de25ec3177c360ee603f44a8db1a6fea5f670a9056c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef4186d607b3c4dfd8844a8297033c59f54af7088cf3f04f6be778a8301a0bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a2bb87fd976955256e4ae770a8bc2c47a6728624edd51460d85a4b44e5d273"
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