class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.7.1.tgz"
  sha256 "804c02a603d44fa9339af89ae75747dcc2d4d91914890f121bdc782dde530754"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b35b226a2ff1eabf032d9eb8db551203b0d64f95e5c6bf77765a3e56156a0acf"
    sha256 cellar: :any,                 arm64_sequoia: "e8355d6a417f327aa9d3bc8792f6a7d5930e68a3df5f8444ff71a23a69fb3e6d"
    sha256 cellar: :any,                 arm64_sonoma:  "e8355d6a417f327aa9d3bc8792f6a7d5930e68a3df5f8444ff71a23a69fb3e6d"
    sha256 cellar: :any,                 sonoma:        "589dc41f4505bf1eae03cd084d2695092ffbea512a20d15384478c762c4d1994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe4420f3f0ca6469ccff364f6b713784ffe486c0f772e45418d319653ea60aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d626f2d771b7afa0a9a065160796c096f9bfe62dc69c3c8afb57b22b0241c6f6"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end