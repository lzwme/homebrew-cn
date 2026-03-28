class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.37.2.tgz"
  sha256 "1b33fa1dd6ccaaed8e91dec2fac44c41024b2807d023ec45366ed6301b2ee043"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a74f07bbf80185282fbaf596a9f1cb7555c42630175e2a046769bb63f3f00c77"
    sha256 cellar: :any,                 arm64_sequoia: "1e7e7433051b1fe4cb9d5806bb214cb230c2748743eb5aab13e3e861592442fb"
    sha256 cellar: :any,                 arm64_sonoma:  "1e7e7433051b1fe4cb9d5806bb214cb230c2748743eb5aab13e3e861592442fb"
    sha256 cellar: :any,                 sonoma:        "e4a72586e7e0c4555293ba305fb7327ca553110109a6ce4162f1d273600ae727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54c68a497c37f4c2c77d422f158f553ce5c09aa34e3a0b0ab4528df7e12a2179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "672a35227789676fc2e2b2e33d4ffcf2b42ee49eb62b253f019ac4453db7fb06"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end