class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.57.0.tgz"
  sha256 "9f4404874930632330d7a67f208e409ae7599ac004e515aae1bc9ae9fe537ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c065af9ca98d28e6529294d01cefab6af772a692f40d664144041b6dd1cf36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c065af9ca98d28e6529294d01cefab6af772a692f40d664144041b6dd1cf36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c065af9ca98d28e6529294d01cefab6af772a692f40d664144041b6dd1cf36"
    sha256 cellar: :any_skip_relocation, sonoma:        "06ca6de235c85bfc372b645c7257035aee72d0f9d003d7d411b40b9eb92ade03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9ad222c6fc6ffde6faafc02b01080b26046b6b7d7424a4be82a612b70dd5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60189134e4fe170368257261cab505585808c7af52079e07cb7fd9ff8efd006d"
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