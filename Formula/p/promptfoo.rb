class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.93.2.tgz"
  sha256 "d2a1fa3248ba85b585f06883532fa2857cb6a118f3920e7f1cf8ecc2f869fb0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38dff175dd6568a4b98417982a2b53cd82faa98a9acb9f362ecd10debd1ce38e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38decd3f2b12e0f7f5a696eacd5999166813e924c82520a2ff79b9c4128b945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61ba8d49bfa10133e3498d40f982b7b0bfb6b13aa0956f66ceb931beed8f2dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc76bbb4942b6ee9677f8e0145a5d6e77fda7e092a3214490d7bb81091b8d15"
    sha256 cellar: :any_skip_relocation, ventura:       "650c6b54751bff5dd16c706cfe9eac57d1a1368febc31995a8cf035c41841b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd2adb8a21d8a2ab61a78a06dee01cb43913b5dfea847fc03de9a9dd2899bdbd"
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