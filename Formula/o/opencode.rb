class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.16.tgz"
  sha256 "c319765abf09da3f4596eeafb0954eb0b96baaf7b388fe6be6a0eca7fdb0d306"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "375364c49e39eb0e0b4db84575818db6ef93e031422ffcb65945363d5514d3de"
    sha256                               arm64_sequoia: "375364c49e39eb0e0b4db84575818db6ef93e031422ffcb65945363d5514d3de"
    sha256                               arm64_sonoma:  "375364c49e39eb0e0b4db84575818db6ef93e031422ffcb65945363d5514d3de"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b49a6eec0287713c1ede910ba04ca15b76cc1cb15d91006ec9adca7f1f75b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb3ede84d70713a7bae59dbebf9322040d63fe6410d25d63753f88c1f6fcdfeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449b646550870d95edfdabc9736031513d84427165f291373d7dad1027905990"
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