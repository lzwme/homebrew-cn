require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.0.0.tgz"
  sha256 "f05f234277b21d8e71018ae9fe606a443794e369c4a22c947de8c87f7f99cd55"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "08a1f27e532a5d7a2a419a77bd8fb71ef7809b1e8fd5b58b47ffb0c3076e2053"
    sha256                               arm64_monterey: "aab430d8ef73923fe1f9f0db6fb8ebb225adae405c6215c1e751b4478b1f4067"
    sha256                               arm64_big_sur:  "9b2f6410f8f808a144b7c83b798ff19cdd7fd047940f9e6f2b4575778a8c63be"
    sha256                               ventura:        "5606d1587e3b5f32f0090e5ff13293eeb70ff04492225ff8d7f807607914ed8f"
    sha256                               monterey:       "5ba5a3539ccf8c8950378f5c06d6922167f55b82bfeba848cd0887104fbb93ff"
    sha256                               big_sur:        "67f6e43e52db3227fd382e11371e1ce84edf2b4ec6633b3015fd611fbbba0419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf855bd54bfc4325ed90113b19a2bdee34b14dfde368b03c6e1609cebe830c2e"
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