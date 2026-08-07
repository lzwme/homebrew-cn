class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.326.0.tar.gz"
  sha256 "975027480e273f9662309702ea23a4ee1f116a1919e51f7faaf32f64965c9cef"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9043a67d70f706c820de1aba4b7e8138a0fd21bc52d46d8d6d29b7009c7378c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c447b4be433983866507429bbe1f950cfe7e127eba76be9f9b7b0094bef7e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06328950c76fcd2f30988d322e8b21f61159d051b490a299c9213b4b716cdb2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f4fe3b7457755bcce060b37fe90b1e93a6473740c3fc868b7df64c15296e92e"
    sha256 cellar: :any,                 arm64_linux:   "b77a6358f90f981bb6de902b4d33892b8396d3db132b10f12051feba4c8f8808"
    sha256 cellar: :any,                 x86_64_linux:  "8d2a619c6e76eccb603b0d450200e717c978c40933efbf546243823f2c1205f2"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "rust_port/crates/flow_cli")

    # Resulting binary name is `flow_cli` but in the release artifacts it is renamed to `flow`
    # https://github.com/facebook/flow/blob/main/.github/workflows/build_and_test.yml
    mv bin/"flow_cli", bin/"flow"

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