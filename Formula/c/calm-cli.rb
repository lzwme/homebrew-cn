class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.50.1.tgz"
  sha256 "6b5ae1981d876750d8201c81e1834be940391f438d8e9edf0fc7a441a584f742"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97d93e540e655093e367dc5ce352a93746fd62d6944a3ed637466d13b6682a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d93e540e655093e367dc5ce352a93746fd62d6944a3ed637466d13b6682a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d93e540e655093e367dc5ce352a93746fd62d6944a3ed637466d13b6682a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "388d7895da62684d60d7aec0dc3cb635bea34074cd9f9d68c43185addb3f369c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f73121e5c28e9d772caa5411b6e638475cafd5d5d59901712e89dfb5fd5a571e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464d075039658f97a55e6192c4ef4159a3f400b42a20c0bc1baadcc3dc719ad3"
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