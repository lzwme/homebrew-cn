class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.1.tgz"
  sha256 "25aca27e3dc7551a686f08ecf507a788e6be6f3f7d5342472402a1d1fca1d8dc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cd15551b214c30627fea429e0e2ba5feeb91f907e4e993db2ab2915d3db5eff1"
    sha256                               arm64_sequoia: "cd15551b214c30627fea429e0e2ba5feeb91f907e4e993db2ab2915d3db5eff1"
    sha256                               arm64_sonoma:  "cd15551b214c30627fea429e0e2ba5feeb91f907e4e993db2ab2915d3db5eff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0724227a23e10eaea59b9ae771db42d79c5756d420cffbd97b6fad21dbb893ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00dd0e7c6f2c503f5c5704c245216abad4df8cc5b8412603a8abacffc0e0308a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad12c66bd1bc30216b9c95f4264fe7b64b2cc512a55193daf96c4adebe653beb"
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