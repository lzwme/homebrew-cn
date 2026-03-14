class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.32.5.tgz"
  sha256 "5e0a8dce724168684613fdb43206502ec21d52ea2b907a642b2cd47ca0b3f63d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45e5fc5582297d8f8082d0b03ae684287cafdbd89e5c9e3a09490d9c0b610663"
    sha256 cellar: :any,                 arm64_sequoia: "9b27d00a35f292d3b4cedec6142036552ebd48ae4bdc916bb09b4e1be648b4ea"
    sha256 cellar: :any,                 arm64_sonoma:  "9b27d00a35f292d3b4cedec6142036552ebd48ae4bdc916bb09b4e1be648b4ea"
    sha256 cellar: :any,                 sonoma:        "deb03cdf530f19952b2b3b35da48edaf89eca2585db3d87290628b43d0eb9d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6a6833b6f306c7fcc8953d2ed342736f39d27158a6c7ea5c08516aa4bdbc34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654978cd0a124c5c3e122acbc217ffb32ee7c69fb0950506c8973879df8f777c"
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