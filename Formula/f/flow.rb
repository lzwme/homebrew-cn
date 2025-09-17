class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.282.0.tar.gz"
  sha256 "781657cf607161436d4e92cf2ffddc4cbb74137ba9b405472c2b16dff9e5e5c0"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fd630f775a40e56fae2cd647162dddfa9bdbb532e757f9d7f73af31bf57bd07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94f35e9e035b65c47da50b973e826072b6f67d5d428e9f607c6226d43f673a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1d075d8ac7bd62cd1fdd8b9b95827085661e32da12b579eac6aae0c614fbdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7dfeed69b346629d494fc587c03ea37c73525e43034455c70f9f0872fdf77d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13a6d685f585eefbd8230635f5b1a48f897b8a580b0ec331a8eb196da35e9416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db9ab6e1840dceebdcced31c5449a9b8240b4a54098cb2e0255696cf4a7cc58"
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