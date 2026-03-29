class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.37.3.tgz"
  sha256 "3140d6c55c37026f75dbc54492446b814e3983e966d10a78619cdfce7f6f13d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0107afc12dcd91862e654bff86a023205b454ebac85be52de3185d01dc062afe"
    sha256 cellar: :any,                 arm64_sequoia: "4a62940630c64ced6584af5ab3ae1eab688cfc3b0e06c92ce53ff9a860cf89e5"
    sha256 cellar: :any,                 arm64_sonoma:  "4a62940630c64ced6584af5ab3ae1eab688cfc3b0e06c92ce53ff9a860cf89e5"
    sha256 cellar: :any,                 sonoma:        "ec561845cfd19df6caa300c878f5233edfc3dd66546e6c36d736717741a390f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d126b0305c26a98f8bde747d3e7f1c446b889a1046b048f77c1a1ff3baf17404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f88fe1b8fd0d2668d022c1d6c95164a490834bf5bbbb1d5f990ea73b32865b18"
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