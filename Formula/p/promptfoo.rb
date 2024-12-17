class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.102.0.tgz"
  sha256 "5a6643666cccb85db1d59600d66209068589e72e7c46a9fe2101f02e39765f0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc11d946d225e5561d7911a50a69eb597409b91cc46b46a6ecc929398923e0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ad459ba60f95f6f974d8550a122560c34743bc0ee099cc82a13ba6865b54b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7a16af9d9822b1bc543304f452f66e65e843edbf5813f7ab444a42baa9266f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2e2117080ff0faa6a9e5c7a4c4f9130c72d2521fb7201fc6d33e3025fa469f"
    sha256 cellar: :any_skip_relocation, ventura:       "d96b9c8865c12a83a60974085517b236e3fe874dc6fc0d8e1e6b905c9b9154e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5919033cd7ea0335bb9d69697eb6d6db8181577c019159048b3e471d1be21a5b"
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