class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.29.tgz"
  sha256 "3b300ab79641ceb10594ca3324476b46528959b93bee9f087450c6ef5cb782a2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a84e108de3686e2759add92da67319addc3bfa190d614caa5f565af7a49f7665"
    sha256                               arm64_sequoia: "a84e108de3686e2759add92da67319addc3bfa190d614caa5f565af7a49f7665"
    sha256                               arm64_sonoma:  "a84e108de3686e2759add92da67319addc3bfa190d614caa5f565af7a49f7665"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbce78b2eb69fe1367bcced4dd3fb6dd393ad7bddbbc39f4633d0d65067d912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef58f82c28cb0713f66c591f240bd9995c4b3884161d42f759dc4bf2812b070f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aedc2a0e1f565324e68ec140c741c3be3c3a93c75dd4dc204c432f41f3dea3ad"
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