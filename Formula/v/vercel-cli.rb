class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.25.4.tgz"
  sha256 "379d917f938857155e8423e5b4681a9cf6b5ff7aa32acffd1e58a3a2797e9090"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e709e9889c1789dc14df7a761c6381e0994272bbbc54bd0bb6a8e3ec00ea924"
    sha256 cellar: :any,                 arm64_sequoia: "86a870ed6f65c5989115199d1b95212e191c75b1758dc991eea4e547852beef2"
    sha256 cellar: :any,                 arm64_sonoma:  "86a870ed6f65c5989115199d1b95212e191c75b1758dc991eea4e547852beef2"
    sha256 cellar: :any,                 sonoma:        "1a1e8ce52b4fa98896f476f922af0ac1e43f41eb2695680e1811f1318501f9e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b2726504b37d16fefdecf2e0d7445d84c0b533f9c1d6d253063dd225b4fbf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6743349cbd81b795a66718f44a08e40b5cafc84865ec5b37a8f8c20ce9cba0ff"
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