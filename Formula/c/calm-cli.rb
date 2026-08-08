class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.53.0.tgz"
  sha256 "f51bca33ddbabc3033a851a43e10b0002aed6fd161d79069c18d44a9821e009b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af3e4db4060f54da44b0991579509079190573bcd7259b178b7e34a718c00d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9af3e4db4060f54da44b0991579509079190573bcd7259b178b7e34a718c00d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af3e4db4060f54da44b0991579509079190573bcd7259b178b7e34a718c00d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2938bd1ef2f63f177acb38c7ace03790655a20393e7537b358541017c59099c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac0c427bb25518844b7bb505096d1d0595d2b95c57d6b6b2b18a355aad46daea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08523423a1edd0b04c152286495ba70c016e632f7f6498a59a3fcc063d8dca37"
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