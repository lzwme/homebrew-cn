require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.68.3.tgz"
  sha256 "9d9b4dd19ed7cca6edba2d4176db82098b9fd954558d8932c84599f5ad61c1c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51a194a60289f520534d6bc65f2b0877267e6ad108544634a9f626f0ea4065b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a77e0541b48606e1618c81866c062c14ba442f393c52c33e367505dfbfa5303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152b1e847f24bc485017b50b727c216f3e1c264141b43a377f36bd9a5a7f44cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "d096bb17bc68e3332af4ce05d30d57677c6d36d4bf435778b26e1af63d2cf292"
    sha256 cellar: :any_skip_relocation, ventura:        "eeec24384e354b4d3ce0bc5cd3c2973566aaed035a2e4dba6509d8504d1d1037"
    sha256 cellar: :any_skip_relocation, monterey:       "aad2b4afd7cda88e3cb861c10f0d9c570f157ad7e27d927bf7cbe9117ad646c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718de81393d4628deaba5d15676afd6c877e838afa23e1a66a78afe908d4473a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end