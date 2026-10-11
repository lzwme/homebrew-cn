class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.6.0.tgz"
  sha256 "c515df1f913acb20667a569415875e7456e7833e1ee146c55ad3d266f06d3c74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a86926c8cc54b6c9dcc77f04042335e4edd8dc2694dfe852f40adc56183792ce"
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