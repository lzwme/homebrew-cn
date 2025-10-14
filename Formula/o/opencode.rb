class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.1.tgz"
  sha256 "99cbf6f1e3c7f00d671c21d990a815d47c3c315c7c51c111200daa11c4dea229"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3a592a31eca2775b28b684d72b5d5665fc9520f618641f50559fa9a294638513"
    sha256                               arm64_sequoia: "3a592a31eca2775b28b684d72b5d5665fc9520f618641f50559fa9a294638513"
    sha256                               arm64_sonoma:  "3a592a31eca2775b28b684d72b5d5665fc9520f618641f50559fa9a294638513"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f0775875ffbc78586129dfd3b2ed3221602c4be34134770e14ec035fe825797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d6eb3e2e454661b3981c31c25132d0a9c8bf9bfa4533344da0ffc6dd2413bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27b3d8d7cfba830e7334d7427e2fa440888c0c701776567d40245d206686f038"
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