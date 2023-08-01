require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.10.0.tgz"
  sha256 "127760f6ad092231a4c41f409a4c54e3369a5f47c7033a13a5709a659ee17550"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "dcf3a74d5fdf50be1a24d289f71b4b77a8e4ca7671add0575dc852afc4319b0d"
    sha256                               arm64_monterey: "67706ff7ead192f1396367f887b4c343b621bf8cc5d89ecce25158350345193a"
    sha256                               arm64_big_sur:  "3eeafeb326efa872595fbec577b67f43bce77bd373b946e749d1c13ec7a78ad3"
    sha256                               ventura:        "2bda0506351a9d797fc8e45de8b0f81a294c19f9e295b4e64e469f666a3ca905"
    sha256                               monterey:       "9a7fcd1078d017c1b5f80edade66fc3c5bffae6b610378de6c36f3ebc25feb07"
    sha256                               big_sur:        "8b451d3ae5bda622d9d231f773292f8dc596d38e178a9ef3a41e164d1183cd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6556aead787e0cc66e4cb864646229f2d1f812121fcb90a11b198d1645fb36"
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