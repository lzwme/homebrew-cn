require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.9.0.tgz"
  sha256 "c851550b871fe3597dd40ffbb3725d88f9a4f1b6e46626d38975e6d3dbbc4c68"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "3aad3c29af0727a907868995a81afd646177eb662add22bedebf43d13fcc877a"
    sha256                               arm64_monterey: "34b89482fdc875aa609dac74737678e6fc23b6425e0ca3b07c5899f76ebee2f3"
    sha256                               arm64_big_sur:  "48a38c348661b4c68bca7d2dee45e6b4507b91541b443df8d2ea8595f402a106"
    sha256                               ventura:        "07c26443872112904fcb89009e38912da9d2862b7896ae5f484a9980b81d71e2"
    sha256                               monterey:       "45b76b0101f881d89fa21dad923d55401335f8428bf952b2d7baf2ff6ab5e279"
    sha256                               big_sur:        "332fb6084a5602ed9ca6447bd5f66c5217390655e757e6bebac68b31d8f8a5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8dd9da35b1b222daa6474c115bfc59543ee7d0f19305cf7acbcc67f420cbad"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end