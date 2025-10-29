class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.20.tgz"
  sha256 "9c4581611105485327101a0f63725706507e512d544ee49564c28dbc2909fb38"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c6591d583945a0583b993eec3c6f0e381e34119cc5b8b0994baf7644e57e67a2"
    sha256                               arm64_sequoia: "c6591d583945a0583b993eec3c6f0e381e34119cc5b8b0994baf7644e57e67a2"
    sha256                               arm64_sonoma:  "c6591d583945a0583b993eec3c6f0e381e34119cc5b8b0994baf7644e57e67a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d51ce3cc90c3e49069f86c229b4b6d53d6e1171d1eaafa8195c63ffefb9b6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f9eafd082a40b1c6fc2442eb0a405e4abaf0177214125cf6081a025014eea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e26bb5a5ff4aef60a150f591e1bbb4e65ccd93bced1556f9c8d24a74e1eaf8"
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