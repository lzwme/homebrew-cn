class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.3.tgz"
  sha256 "e609b95e6d40c171f6ba12671ee4c5507c2222a12c96364b4d649b2a7ae0cc38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eb537617e8367fb12b0a9f5ef6c05c1dfb6e316e2392fe4b569805e9c0be9d6"
    sha256 cellar: :any,                 arm64_sonoma:  "e51ebf0663a949fad55d92f4eef6f659d69191caec064bb4aa658443a6ceab88"
    sha256 cellar: :any,                 arm64_ventura: "c664c282cfd1f39d81a4409993ca0fd05491848f8af757c8cf446126f71eb8ce"
    sha256 cellar: :any,                 sonoma:        "ed718f4b9b6ad57fbaf0e2dd3e4428d0d5d5978ad053afaf069879d7b3cf1b6c"
    sha256 cellar: :any,                 ventura:       "d565c94c9f5af802d8a82402fc20ae32ea7aec68f09a3dd612bf2ec9db0d7016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50362d649842ef324b7fb76134149c34bf50afee879dda72aea0b03450435398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c5a9b58863600e6f3343d37a3f60846e28d7ec4a805d4943e122767e5f9517"
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