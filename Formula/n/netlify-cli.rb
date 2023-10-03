require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.5.0.tgz"
  sha256 "8568fce127fe2b75ff1d15e2461c62cfafb6bfd90f0c22315fa49bd165e9c36f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "282e27820e1284c92d5c0bd1f426d876b2a741ea12f3f98d6af0d6f7fd4d0661"
    sha256                               arm64_ventura:  "4b57337bcd35431283fb9d3e7cf4f4e3693d1583960b7b7eff819d0d669914a4"
    sha256                               arm64_monterey: "2c9ff8d5395f21bdc176aaab07fd6a50bed0457928c5829b1bc63d17c50d7f11"
    sha256                               sonoma:         "3fa49700d99c212329d16ab1ec7109a780f99eb5b344bf8071dc144ebe00ad27"
    sha256                               ventura:        "7f07800389243ed5eb9cba7ff9be0cb0581088e4fb3c97fe33e09faa3ba5a513"
    sha256                               monterey:       "de0097486ed70bbb929dd65ba364d15f8a66793ef6cac3a64d95c6817a44e7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4d69fb856404aa167edfffa08d06e86c8c60ac2dca1043a89dfe47bc64a67a"
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