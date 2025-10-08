class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.6.tgz"
  sha256 "c4e3be3e6ac2e65f5c011c1eada18c3d093e42e6e0368a12cbd79af7633f3a54"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2553b5b7d62bd600401a58a70d67f748e27e54374c80b67c2632527ca2fb87bb"
    sha256                               arm64_sequoia: "2553b5b7d62bd600401a58a70d67f748e27e54374c80b67c2632527ca2fb87bb"
    sha256                               arm64_sonoma:  "2553b5b7d62bd600401a58a70d67f748e27e54374c80b67c2632527ca2fb87bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f1cdd6983fcf5849eb91136e6adfc5c319756f052f9fb40ebd25416e5d7905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a245f773d323e49f1882b4d47713dc989a8f74246a29985d38ee5563f1c653e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555300c0252971818fa0dbc8cb32a880609da123b7c92c9b0f4319065f84867d"
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