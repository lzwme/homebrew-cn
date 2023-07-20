require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.9.1.tgz"
  sha256 "5785bcc5d39f39a5db2aa9d279a8e27e162cd11a47ec8e55855a75a6c076cfe1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "3c1b7205bc1c4e5a2261f4febfaa77f77cc16764f9c30c1f8c5ecd16f35b6c0d"
    sha256                               arm64_monterey: "e5bc202e84c7561680f11ea9502e53f352f50828b85bab587a807aba18088a08"
    sha256                               arm64_big_sur:  "4f4b206d0b25760dabb455812e7c14cd8dafd920f35786f7155b558e133d407e"
    sha256                               ventura:        "c0769e09f8bfa96b219f0532f5c3f891c4041f15d8bdc2691fc6471a0ea390f7"
    sha256                               monterey:       "987b345e76ea36f20e7331a8f36b712a760098b84eb70eb1625fdd0c098d38bb"
    sha256                               big_sur:        "df9dc0942da9f65b0fe119660756927346934101b2189162bb352b5129860c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dada69bd6d984a2f6abac4105452d413d13b43e6d8111824c5c7e9a51d0a726"
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