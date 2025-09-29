class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.12.2.tgz"
  sha256 "d7a9b60e7a2132e876701b790a05683c0f9ac2f620aa1e1a99668e8a079d9c0b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2e7c75f4132261d8ef6662c5c105bd84d1ef4cc92de81b8a28b3739a76cd279e"
    sha256                               arm64_sequoia: "2e7c75f4132261d8ef6662c5c105bd84d1ef4cc92de81b8a28b3739a76cd279e"
    sha256                               arm64_sonoma:  "2e7c75f4132261d8ef6662c5c105bd84d1ef4cc92de81b8a28b3739a76cd279e"
    sha256 cellar: :any_skip_relocation, sonoma:        "915d9db79ce370cbb0f6300a266d9ac95f6dabbfd6d5d16a2dc3baac6be04d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92faa2a36d12407b1577ccd532ec2fc31512e9a27ab43ebf6bd0ff8c0a5c13ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ec6d9c8fed36148aa3b42559dc4e2638099db359664402162a36c4692afabe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end