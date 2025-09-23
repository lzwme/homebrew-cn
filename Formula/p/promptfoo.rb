class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.7.tgz"
  sha256 "c4b93d05325a10abe09bb43429c8f88a0b6fc4666189e32c9fc5a922a83d8d4f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98c3c226601603975acabce30d2c23ceab40c78a439863f13377edca2df4195d"
    sha256 cellar: :any,                 arm64_sequoia: "095a24ffe73ec41563f25e7e9009acda0bd4bb158054418806276fb918bb9f21"
    sha256 cellar: :any,                 arm64_sonoma:  "e1ef67e8fcbfc2e7d3336764509c0f6f276fb4dafe7c1de71a03c44f2a291c97"
    sha256 cellar: :any,                 sonoma:        "bc635d66ed7bba130ca8788e7780038d4c6c0bd068eca4245aac3df71f7291a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac19da7119df6616f710d68419278d6ce5a290f5dcf142c60dbafa4118b4984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f7339199003f846fd25e19414848ded938441359d9f7900dc5828ea2dd3d23"
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