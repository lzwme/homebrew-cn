require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.4.1.tgz"
  sha256 "8456a1985d5b6b656ed920dd2c62e41545ba10cb87a0b9913945723a9ddeffd2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "74ffa3068d34e0995b9f50107e5f2d53956fd769f783db93c6bca3c2ef4ebe79"
    sha256                               arm64_monterey: "24e85d6eec2525377f65abcde1b09d011912adc8a0ab9721c49cba0ac3bc5df1"
    sha256                               arm64_big_sur:  "5e37862e3356f3d68db0adcbc6761e577e8a74214156308440beb8e042030857"
    sha256                               ventura:        "9a14c1d04a0bdda4bd5c5fee563c1ad093e61ea99c0c39ff6c597ecde0e822a2"
    sha256                               monterey:       "7c284cbc2e395be03c6180ee69cf3a72538c4d6bda38a43ae98f378a05bf1ffe"
    sha256                               big_sur:        "17757ff5d4e972c70f0883a0fffee9dacf25c952080f2f770b49079dea133752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd071bb3856393199bd083776aad6b10c95ab703d5be867b5a51d6c3411d0be"
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