class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.7.tgz"
  sha256 "8a176b1a2d1c2937983dc25d7be5660396b5a3be62773e450041d867d861d6ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5f3df08a3dfa9e62039b595c387fe7be90946a2f61e3df733cc3e4db926a2f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end