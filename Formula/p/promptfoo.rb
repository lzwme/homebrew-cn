class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.85.2.tgz"
  sha256 "ac2f8487e62949bfc38d9023e0709cb0b9a0fdfc9ce4944475f54b5b57a74131"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5655ecb81661b2690211a3605d2d08f55847a6fcfffd5af3d737365c33af8b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2bc57093a4066f8352108fe0c4f7e77229a1bf0552b4e59ddd1ca28054de5de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8828507db2c463ad55b44b55b60ec8da14e060c5ee9ae130a31788ef9abdfb09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb23f895000aacc131a33ef6d8d7c1d154e86bf0e9e6a90773754b5d3e117190"
    sha256 cellar: :any_skip_relocation, sonoma:         "87cbb9a0ce7634ee60b7f3bb586030d1c3ffe9d6fae6d8e01ae8f9bf9919932b"
    sha256 cellar: :any_skip_relocation, ventura:        "cba3fde39a949238cc6560bf95c378e041a70ec2ee036456412f5a232e90e332"
    sha256 cellar: :any_skip_relocation, monterey:       "0e440a74d77fa25f8c4319ce3e25961e74d892766eaba58fe1817343bae8070c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8facbd41179a51db24e15d092ac28934af792839c894c93b0de0b515d600c9c"
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