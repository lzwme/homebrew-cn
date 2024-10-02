class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.91.0.tgz"
  sha256 "b8a2bae3786aa9875608caecf70d846bdaa0685391d3fe5a48d311c64a22da75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86457e69ae577ea5b2eeb2915eaaa2a9229c96387a0b07e1271a7ccff15d5229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4bec825906da4667462f3772eeef5e8a866d5adca2ebda06231cfb2ce150cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6806f330ef3a6329d96c7131fa43afbe40be2a1026551b1bc01d9d3bf964a42"
    sha256 cellar: :any_skip_relocation, sonoma:        "562c8c26d259e8be7b958661cec516b395049390ac3cbc944f1485d7b7856aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "8f430aa02ed4dbd54ad94181e3422c96de2cb794a519bb53229cd58afca78bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9b3d1c0b902b86d1ee5d2cb3afe9499411b93d21556005e3cf822a504bb802"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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