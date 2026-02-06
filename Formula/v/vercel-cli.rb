class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.12.1.tgz"
  sha256 "3beb5077f9e77cce8afed2fe463a000b520662cb706eaf7bae4b7c43b98796ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0fb26b17c4696578f11abaf9787fdda8a976849246b449986969b84ba099ebf"
    sha256 cellar: :any,                 arm64_sequoia: "1e5caee2f4c7715af71c7f32aa66ddadafb76389a0def85d9f829fe0a9c451c8"
    sha256 cellar: :any,                 arm64_sonoma:  "1e5caee2f4c7715af71c7f32aa66ddadafb76389a0def85d9f829fe0a9c451c8"
    sha256 cellar: :any,                 sonoma:        "3a46ccc8ad7277868a6655534f7d7d4a91d5f60b041198be08ce9ab27e03f69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "969a7caf4b8ee3e05a920297a5e0599b778874d0ca94c163652670b2e684839b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abaf91dce5527f4caf37adb3d45589cb68b9230e7e55b75c61b4c24b88dae724"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end