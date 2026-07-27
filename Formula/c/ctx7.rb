class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.6.tgz"
  sha256 "0c7774001adc7ce670efe4c7e06400265b8450c9d7e155c8f80c1d3476df4935"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aee9453e44a7ba5ecb55f15adc5156299392b5fcb39b0d02d6fb4cf4dc1aec9a"
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