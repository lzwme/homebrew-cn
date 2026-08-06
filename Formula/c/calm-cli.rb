class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.52.0.tgz"
  sha256 "2b2c7afe966af84585bcef04f8ccf61c75f3720d89627a7a8b9ac12ef3f4cedb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b53488a6268fab34e339f55f129f1b2a571e33a1cfe1500196db7c54c1dedc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b53488a6268fab34e339f55f129f1b2a571e33a1cfe1500196db7c54c1dedc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b53488a6268fab34e339f55f129f1b2a571e33a1cfe1500196db7c54c1dedc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "43e5575a72981f48f60eb9969df652a33d2ecf905aa38e9e7a5f41bd123c9484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89763e0702d62e778baa376ccc3d85413f63fe531d0cb150c34b2014dbc4b4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3f5a68e6b31a8b95ce670da63da0a3e3f7ad817289a1a2557d38e12f507d70"
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