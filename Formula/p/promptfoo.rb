class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.5.tgz"
  sha256 "2a0750c36eca2c53baaa7a72f49a6f9fb7ee37f35b396caca3e34c482937b45b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "386a418779fd9a7b0c0364a596f7d71553fa9877a3c8b57656ce4e12497ca9ad"
    sha256 cellar: :any,                 arm64_sonoma:  "2c1206ab5509d970fbc06c0d823dccb0a5ca9e2febf3bf4ef433917db1632b9d"
    sha256 cellar: :any,                 arm64_ventura: "f97f0cc9a73412db091f76372158c8c8dc249e5d263be3114e09eb5f7e1b79b6"
    sha256                               sonoma:        "396f0e0fcc95120b19f446f074b77eee00a530283eba9607015dd0fb58a2c305"
    sha256                               ventura:       "4f055ccf55c7efe3078bb3c24e78da4e2b7c12a5802f42db0bf231894c925d26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614aa9b4222df4f5d97009d341e50f19595c82ad75419173393c94f08ecc4c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a9bbf8cfabfce550e8e55270670e31d5d8b9cbc91bd630b29188c1c0dddd626"
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