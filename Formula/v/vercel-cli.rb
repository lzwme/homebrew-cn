class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.9.1.tgz"
  sha256 "e0add91eceecb0eb44c8a0da48c1e1bf6638081bbeed280fb304e129918c3f59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94ce6f64aa409db65baff1b6f926fa498c5f7f58e0ceacdb08ace7971e965375"
    sha256 cellar: :any,                 arm64_sequoia: "6984db59f8f9f5f9002097458222be44b80988b217467399d6195d2e50e77a98"
    sha256 cellar: :any,                 arm64_sonoma:  "6984db59f8f9f5f9002097458222be44b80988b217467399d6195d2e50e77a98"
    sha256 cellar: :any,                 sonoma:        "c3491812532ba309b8f2d0c9c5cca33ea8aec74ffa637818f845c8f61656f9e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0798e81a3785cb03608d26a150ebd946d31a7f0f77edcfdceb2fc02ed51993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70b8c992ab2e2f477cde72d071c2d7e58e962c1d987f8d0c01a65478513e451"
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