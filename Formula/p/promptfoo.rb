class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.11.tgz"
  sha256 "fd0ccf12e3c5720598ff0b64d8d32e26454b97325fe999086b6fa820e47ec56e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52aa1e245058dacbdc2c850de68e342fe2facce13018a06573988f278c6937be"
    sha256 cellar: :any,                 arm64_sonoma:  "46d518906164aeb4dd99fe6e84e5464378c64ddf670e043ceb53999fce81d84d"
    sha256 cellar: :any,                 arm64_ventura: "ebe72bc74461a270c0ab3303dc291492837276621a99541742390153a09af572"
    sha256 cellar: :any,                 sonoma:        "7d604bdd5b81c5611eb3e1e97a32275b54e6c8b0bddfa857421b46af94868fbf"
    sha256 cellar: :any,                 ventura:       "09727a0e04b58bc0717182a2c73817da7cdbc8a0d9adabd3fc9ddf6e5d9dc161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94cf1300bb5f4cc22ac8c54f5ef591226d8f1dca97e4f187c1c5ddb46bab861f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b8eb837fac97b9e446cb6fdd9dd18bed0d40075248693b4a449e098bf21073"
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