class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.116.3.tgz"
  sha256 "fdd98841881a3130ecd4a608dc4f0e37847bd6280f6ae2395eed675fe1bfb6f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ef534f5feb7095b612b684165000d957b5ff6b6bf3d8103929d2d5290fb19de"
    sha256 cellar: :any,                 arm64_sonoma:  "53e5efef43d621b1a094320511b80dcde413ad336a5e9059f3c7cc333761ad9c"
    sha256 cellar: :any,                 arm64_ventura: "00169c2f8bd7f4a681a7d0b6304e0160ae9c848f4516dc45999a510f4108593d"
    sha256                               sonoma:        "8a7456307f3584bc3d2b4b5320b96d98b15799a834b9c2544799a8fadad477d7"
    sha256                               ventura:       "d58ee80cb61dd1cf78a0fd210a05de6bf2fb942462b5f013d1302d933ac84800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9599c7ea4643b889eeaf7bffb3f05694a9e98a2ab143f1031f20cb0f8a4627e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "871cdcfb2230b687b54a4dbcb64050ac3a53b50508fdbe6f75b1ca4aac0af278"
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