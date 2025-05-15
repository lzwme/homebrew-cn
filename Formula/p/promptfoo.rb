class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.6.tgz"
  sha256 "a94567f60736812f6f98622801fbbf66e2a91f3ee3748febb4136f5d61a010a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33c7e8d85bd6756d7b0e83f803cfb95e8b3030e1f9858c921e3eb446057f77d4"
    sha256 cellar: :any,                 arm64_sonoma:  "74334d6ba2a1435b043e9fefa6887c68ab5c593a905c6351d830786a76a665da"
    sha256 cellar: :any,                 arm64_ventura: "bcdb03fe0dbd17ae81b619eb0eb124fb0957715ca5ad14bd6c33bfb811c87c89"
    sha256                               sonoma:        "a3b200d10edcf100bd31453d4367b214a6a81aa0405c8c4f00fd2c2d8a68f574"
    sha256                               ventura:       "5ccfc595ed00df3b25fc6ab99a9268d7029528dada3e303b2e9bd00f0f1f3a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8505e5b63ffb943e1d3071c20e57e6d2af0c79ce87304d76ef271c9ca03444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8490ffc55c7fdb523949ad92fd5f8bde2231b6a1d995e0f7562da7fca912c2"
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