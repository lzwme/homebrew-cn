require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.9.tgz"
  sha256 "e2a20c6fed7cb45a06a634e91a6a2a745b44a97456967a74cdea2313f24ec30d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94052aa6371e7c3a5a3cea842435d9fbf05fabc5e5371195f7e7c31e774ac29a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049e2ea16563df230069c4dfb93dfe0453d053d2a013c1d61de19b22c1281587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48287f3ebc5a4073864733154b0251d3e3e5218da10f0c423eadcbc388aac0b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e6a26bc1a28b3fede0129b1a56af20c65092e6c407f0ec55967dea519c21ef2"
    sha256 cellar: :any_skip_relocation, ventura:        "4163dbe556ca2794b0eb8b37eb2ad1411c002301e99a5ad7f6a40f3182e1ab8e"
    sha256 cellar: :any_skip_relocation, monterey:       "f528c374ef6270552a2046096c3a6bf7f55a8972de776323f08399e5037a69d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ffd3f506f4754ef704e3e796e7b36f0fb5d6f3a5a5f6f6d8a941d6287e6f1f"
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