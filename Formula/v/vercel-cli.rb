class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.2.2.tgz"
  sha256 "2e7ecf2418437d1b9cf347d29d28e56d244e503ae08e49efea100892934a1429"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c132f8ce8393a41116b0b660bba99fc968f399f3006753b4f11fbac4141a17a"
    sha256 cellar: :any,                 arm64_sequoia: "e24e0cf09cf2f9adf3cb7644a931d6359420584d22d5f089225aed732d9bbab2"
    sha256 cellar: :any,                 arm64_sonoma:  "e24e0cf09cf2f9adf3cb7644a931d6359420584d22d5f089225aed732d9bbab2"
    sha256 cellar: :any,                 sonoma:        "640f94477a8e66646e5f8338b1233ef2f7dd0092b1be41567df645cfc0c9d57a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af30e26682b12bca176d4112007626f5c5326d8f8e51a3b56affb82540a61245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8d5aceb289bde219c984f41e2b282cf3203aedd15554d09335ee40590a51fa"
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