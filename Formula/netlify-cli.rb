require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.2.0.tgz"
  sha256 "1fbd7da18ed81aa038f8e0374741b1833a8f19accc9dc071d06a60266acaa8c6"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "950d07cbea04aecdc50f79c00a316aa9b0243beb03f467f3253e7103ee5bc1ad"
    sha256                               arm64_monterey: "e9219b6beb4334198946ef32583f1591c7f224a6117ef1733a4b4674ff69a2ce"
    sha256                               arm64_big_sur:  "3be1e4447c8c2a0696b3fa9a090a8cb6761627c0aceaa267ab1f17849309693e"
    sha256                               ventura:        "fe4885de814c08ef4585bd80ce14cbba979c26a0694547fb82e6caa3ced0bdf1"
    sha256                               monterey:       "87acbf69c610a24764a052715424e5f0843f09cf1b9f8e66aca6945c41762ba8"
    sha256                               big_sur:        "d32e0a137f1b21e79976be2350b65b7a888adedd9253b8e9a00271fbc26f7860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "312a51e1ab5b62a78442eac74b010cb2d5cbd4431d215fb7ab01146413c14c82"
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