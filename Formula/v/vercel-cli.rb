class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-42.1.1.tgz"
  sha256 "c854c1e12d278b879289fbac9993c000a02344a0cf77ff68b1d04e5277be3674"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc3d1223a55a9f6752786ed86ce5cf2804970c7495776660b844b41b9a1028b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3d1223a55a9f6752786ed86ce5cf2804970c7495776660b844b41b9a1028b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc3d1223a55a9f6752786ed86ce5cf2804970c7495776660b844b41b9a1028b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e7241ab43c8652334926d58e6a1d2d46cfb691144bdd575c949a2f1101c6b2f"
    sha256 cellar: :any_skip_relocation, ventura:       "4e7241ab43c8652334926d58e6a1d2d46cfb691144bdd575c949a2f1101c6b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd53eab560fab3b25b74c559e8d8d242016df055c0be8e1ed2a2ba01f7909ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991cd3d2b31afcdb6cc8c58f4f25d2f3b2502b0b5ed3b8332c76db76660711d1"
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