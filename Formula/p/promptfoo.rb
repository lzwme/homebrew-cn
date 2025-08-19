class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.6.tgz"
  sha256 "b87ea9398155ee8f602ae995d5d4a98e5405a543ec9a8dc8e2913bd589bfa010"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6223e3a7d7b6c405a6cb5f45f2c2b25829d4aa5715095c25e3aa26cb950f76c3"
    sha256 cellar: :any,                 arm64_sonoma:  "b0e2c0c0dbdfde33786ee5544192b9ccfbbe8a0f986ff81eab56d901313301b3"
    sha256 cellar: :any,                 arm64_ventura: "a268fdd7a77a8869eea9652a5df13b70862f538edb2c694f85633787de2c58c9"
    sha256 cellar: :any,                 sonoma:        "c400379e7eba23363799be3b2f3a2827582cfc76645738c7e4f1bda75f7eb807"
    sha256 cellar: :any,                 ventura:       "94e5398258e662f9613cd30bc7c877695e56c0afbed6ea2adcec2b23ddcd80f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c70736a311b031b9c6d7a49228455537e35c3eddb3440e8be11b5442cba97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a1b034fb5194c7514bbdaa43905decaf018443267e1e5fecd740f2ef230b13"
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