class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.54.0.tgz"
  sha256 "f41b27558ca641503d9d81af5da2e9d11d81cfb1e869f4e99e8b457729a8b4a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0483240c76fbad492a143457ed31ca5eb0cbd24cac76348c1ae213e0e14f2cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0483240c76fbad492a143457ed31ca5eb0cbd24cac76348c1ae213e0e14f2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0483240c76fbad492a143457ed31ca5eb0cbd24cac76348c1ae213e0e14f2cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "176fd53c21a7f4e24f1ecc3d22191e9662c6d44c0f80ef852580dd5928c23e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e81a8b65ce36ba3a583422c8b09db295eae0276aea63e21d2adc04587fafdf95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f0bbbbecadac8e686e1345f13976156fbf8bfe41870b5d885c1d1ce7eb58ef"
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