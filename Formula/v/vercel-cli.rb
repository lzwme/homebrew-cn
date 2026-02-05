class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.11.0.tgz"
  sha256 "caa12208dbe34adf04f2508b5d0e073307e08ef983dcf2862391e102f3366d6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1990863391e96ed537648ff4b7f4b2a4a1e017a1f26da1a9b1afc4fda29c549c"
    sha256 cellar: :any,                 arm64_sequoia: "bd59ff8bd8886ec13d160ba1a7a238a6d06d5e4fd0c57951bcacfca7b120ee22"
    sha256 cellar: :any,                 arm64_sonoma:  "bd59ff8bd8886ec13d160ba1a7a238a6d06d5e4fd0c57951bcacfca7b120ee22"
    sha256 cellar: :any,                 sonoma:        "657694eabefd2a5c2c1eff6c617eff1ed39462f21df4eddcb58abfbaac71d6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391767f07a73f5c2a79a2989fc8fc60b52e8a4528f07284a2ca7f56e451593c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f37fd887db833520569ee6d5522deab209f94e9801d60d970d1724b0a5e8f68a"
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