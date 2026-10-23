class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.65.0.tgz"
  sha256 "ac2215d2d46e83ca9fdd04f8d4c8fa04e6a48726e88be15bb770fcc4b81982bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "339c653a3d2a25506fe74604a9da46da16e03afadd7ea2bd37467729f73c5b6b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "339c653a3d2a25506fe74604a9da46da16e03afadd7ea2bd37467729f73c5b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "339c653a3d2a25506fe74604a9da46da16e03afadd7ea2bd37467729f73c5b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57f0003545ceb3c49ba38f6057fdd17f68c16b668a87c522f39eff10d4ce484d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ce0b111ef977a0abde42577f3293af5fd2a708f35f94d5ba4747c48029964a5"
  end

  depends_on "node"

  resource "testdata", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
    sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
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