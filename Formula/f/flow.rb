class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.327.0.tar.gz"
  sha256 "8185a0ddc2714ad16a58dcd60d0993a261e56895a81f91270cc19bd86531bf22"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b6d7b3f53fe48c86b3f4951c80670d2a72b70c353e2f700ad9be760e900defa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60fd52fe9e412f58dd072999589fbca3cf9bf544738547ceac4f451cb689f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acbeb39f669ea9ee2cb92bf82fa819eef3863e2de6b01a6393ad1a5f79cb2fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dacff44c95e6e9b3a0967e1834f7ad00e89e551e85f326752cc140a596f8f5b7"
    sha256 cellar: :any,                 arm64_linux:   "485cbdccf1dc78cbcab2d711f303e73c8d2cc85cdf42f238fc63722590a5f43f"
    sha256 cellar: :any,                 x86_64_linux:  "c8ec8ac06b549a6366eff6ab4232542c273012854029bd86533d9fdbe4ec8f43"
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