class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.2.tgz"
  sha256 "25c318856ed43aacc6bd4362f0a0ff97e9aa9769d29d10045fa7733b13249e47"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19a017e256f7f396db2720d655085732e44dbb6f9cb826f453715da23bf8fb75"
    sha256 cellar: :any,                 arm64_sonoma:  "0d0c46a360f49a4ff7440145ce7e0bc990b1ba652339360f0987f369582a8f6a"
    sha256 cellar: :any,                 arm64_ventura: "4135d4c686e63dae33fc836c5478101c2b010b40a0f29309c18cae67606dd1a7"
    sha256                               sonoma:        "17457be4231ad7070ba5b652f5bf09596139b8b4abc36850940d2c0c113ba03b"
    sha256                               ventura:       "505f47d50053bfdaca353d20fb606013683b0d2c825d2abc5510db46f5f3e029"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3022393b959a9558521188801e033bd84b01b6af170c056444882ccc63097c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c5923e054b8a89dd32d6a3f8f831ef8273cf8143e04c7990ee1ad59681eefec"
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