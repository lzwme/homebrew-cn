require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.18.1.tgz"
  sha256 "2a1bb1b787bce974bb709a851fe6abd2a77ac939017597150751a855460ee071"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe89a153df06a54db99238bc38d3b0e5c016cf62608eb6ee3b6868b46a43ca01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe89a153df06a54db99238bc38d3b0e5c016cf62608eb6ee3b6868b46a43ca01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe89a153df06a54db99238bc38d3b0e5c016cf62608eb6ee3b6868b46a43ca01"
    sha256 cellar: :any_skip_relocation, ventura:        "affe398e8ad9598bcd3e78cb01739bd407172e8393a8f7dfee61b00d63294217"
    sha256 cellar: :any_skip_relocation, monterey:       "affe398e8ad9598bcd3e78cb01739bd407172e8393a8f7dfee61b00d63294217"
    sha256 cellar: :any_skip_relocation, big_sur:        "affe398e8ad9598bcd3e78cb01739bd407172e8393a8f7dfee61b00d63294217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3775e239c2d150293ad74071383d4a4abaee0bd80ca5fc18f62ad366f38a2c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end