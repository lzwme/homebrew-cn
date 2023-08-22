class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.215.0.tar.gz"
  sha256 "f5e3edc03fd2902c6577d66018dd7d8ea37df9a9ba795a5b7344e32db4ff4228"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b8e3923ad3502bc17db165a87c6b78f1cc6fe73bbfff24e1a273371e8d3932b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef8d018938ec7daf339d38d813c2974821791e9ff47772498cd327517a75a2ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75e125d153022e22c05f6a44bbfeb4cabb301bd7c339739d23554932d156493c"
    sha256 cellar: :any_skip_relocation, ventura:        "e7963eb00a9df6f053b5ce3731e4bd4653c12a5bcee2c29c7ebe91e195d2903a"
    sha256 cellar: :any_skip_relocation, monterey:       "47bd12c369572ba61c705a821b09b984d269e091412222e764fb1211c94a434f"
    sha256 cellar: :any_skip_relocation, big_sur:        "32b0f0d41a98b110e1732e94d6be4c37065b9ead1cb6538b18dd3e32ba79692c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fde7a3d2563cdc9f1471577eb0b48e761bd61b91bcd22048dba5bf130045b3e"
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