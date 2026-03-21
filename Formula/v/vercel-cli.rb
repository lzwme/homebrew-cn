class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.34.3.tgz"
  sha256 "f1ab8305283078a2a9d083702af06d73924afe0379ee5475de676798391bb1da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fe9e64bc3479dc95c541bf8f4966779f5e5b14f870d6988ed2ae7fb2a8c4551"
    sha256 cellar: :any,                 arm64_sequoia: "399633cf344f4bd23eeddaf7c0cd3106be85835b67cbd07de35701fca7d466d3"
    sha256 cellar: :any,                 arm64_sonoma:  "399633cf344f4bd23eeddaf7c0cd3106be85835b67cbd07de35701fca7d466d3"
    sha256 cellar: :any,                 sonoma:        "1570af48b2c595c48bc11215866ce3aee066662c2380dd726c9c192fee5bb99b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cafd75eb9768a7886fa225ce80af60c7ba67a8e659e41ba0bc8fb83804e18fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece400a7828db192a3b930ffa7e08d1f97d9b7f8b5d3666c5ba41dcf8d85caab"
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