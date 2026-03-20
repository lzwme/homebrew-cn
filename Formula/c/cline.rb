class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.8.1.tgz"
  sha256 "27072c1e299a6dce2af10f52310ecdb2fc9d2d6de0e731c3e0d29f4f8e04082b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e5c14206324b030eebc15cbd913d367782910061d76c75a75d41d5998460025"
    sha256 cellar: :any,                 arm64_sequoia: "cd455f86012a7d3b4a95245aa34c9f869e68e53fd26af923a37060df372e2572"
    sha256 cellar: :any,                 arm64_sonoma:  "cd455f86012a7d3b4a95245aa34c9f869e68e53fd26af923a37060df372e2572"
    sha256 cellar: :any,                 sonoma:        "3e658cae6b2cd0f7bdc3190a6e625e585478fc65b750f564883724b255a600aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0085a8d3e367fcd31a78c6b77a20e7091bf7481ff6999345c91af0c7da62f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb1e099f2f9e0ceb77cc5ff0cd37a2a473a5917836f4d87146000d3178e6b91"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end