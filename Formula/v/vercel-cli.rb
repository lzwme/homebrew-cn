class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.37.0.tgz"
  sha256 "6975af3d9a72e00e77b00a1d50971c0bbe7ba9ebd7bb3e372ba35b46c493c0ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b9e092a8615476e3c0793e7cc53ed898d7eef21a6c934dcf8a6351741807da1"
    sha256 cellar: :any,                 arm64_sequoia: "acca1ed38ab46112f6e168614c167ee7eeb17024c59957aec17f1573308a5f3b"
    sha256 cellar: :any,                 arm64_sonoma:  "acca1ed38ab46112f6e168614c167ee7eeb17024c59957aec17f1573308a5f3b"
    sha256 cellar: :any,                 sonoma:        "5bc686018082a6f8f31ad3c8dccf1d14cdf322c68a4ef683d516104c8ec0b036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81aef7eca713713e15217bc067ac03a585f811187294e1188c6913b6ee9c094a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed11997ef79ff07e496350914f64dd78bff6da548f1abcd67f94bb8c134304f"
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