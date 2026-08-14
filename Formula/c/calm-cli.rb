class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.55.0.tgz"
  sha256 "fcfcd6c35a54e92f5be31ce68f6b2c175c509fac6bc028d1e8faf6347cba56ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a0d953390a4dfb954379acc00aea9ac2a8a396e4124f1f0e9be1832bd90f741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a0d953390a4dfb954379acc00aea9ac2a8a396e4124f1f0e9be1832bd90f741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0d953390a4dfb954379acc00aea9ac2a8a396e4124f1f0e9be1832bd90f741"
    sha256 cellar: :any_skip_relocation, sonoma:        "e462d5a2c52e9a248f2be6703d081fa4c2af2c57a70d40d3e4ea4673d7754098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb22bb6cab71aa71f89899658e3daa8277f5797a982cfcb718a3e52b5d41f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532e988078f97989b1f4c6c9be1b40eeaa4fff65f7c25d66ce78311c6f22686c"
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