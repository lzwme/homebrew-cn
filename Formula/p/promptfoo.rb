class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.1.tgz"
  sha256 "0880b41166d1e49d36d3572c1101ba53ec5d58b787119b5798d0d20b153f45b1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5aba3296921f792d1e4bfb9d52d85e2b617871836914701ea132f51ee70a9aac"
    sha256 cellar: :any,                 arm64_sonoma:  "7dc12d3a18cff0bd0a1802870cd6d4f676489af1441c1802845ca5b68b50c76b"
    sha256 cellar: :any,                 arm64_ventura: "a14d68680a1663ac9394c7673afa13dcccec7f81920ff0ebec9c2cbde181820e"
    sha256                               sonoma:        "de2f2cbf8330b6aaa9e6c79bb25732b8de0eeb99f814cc69d065d15b950c86e1"
    sha256                               ventura:       "e2b646d65083f635b747469b0c553f4bfebc03f52dec5ea3f5d5ee9f7276fc2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ac6ed69c6280493525d3cd8303ee12a0e11ce7c51c3ead2fa444094b0e6792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49edcb7517deaaf66aec7657dd3f40a82672fd3bd4c5a12e120c727889a7b64b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end