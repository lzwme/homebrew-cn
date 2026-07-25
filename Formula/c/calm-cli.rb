class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.50.0.tgz"
  sha256 "4029e814b6e98d26370f6ab3fc7551456b9e46c92cadcdfa140386ad7d224667"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e506b71425add295ded7a81dec87f9c9acce3c25c611dc59a6a0e5d9f39e82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e506b71425add295ded7a81dec87f9c9acce3c25c611dc59a6a0e5d9f39e82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e506b71425add295ded7a81dec87f9c9acce3c25c611dc59a6a0e5d9f39e82b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b772f389f02fdf53dd1d3e2fe4bb011b16d0d658cee24490ad14a46615f256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff168ab9e9c5536a31ef8e0314f84eab006b4d912ddc59acffbb04a26a6328e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765e275e4c18224a7522a88c5c651d4fb8153c6acd7aeeb58ca3d7bbc63a560b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

    testpath.install resource("testdata")
    system bin/"calm", "generate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--output", "./conference-signup.arch.json"
    assert_match "conference-website", (testpath/"conference-signup.arch.json").read
    # TODO: restore `--architecture` roundtrip once upstream `generate` emits the `control-id` required since 1.50.0
    system bin/"calm", "validate",
                       "--pattern", "./conference-signup.pattern.json",
                       # "--architecture", "./conference-signup.arch.json",
                       "--output", "./conference-signup.validate.json"

    assert_match version.to_s, shell_output("#{bin}/calm --version")
  end
end