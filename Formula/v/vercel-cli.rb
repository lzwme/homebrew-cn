class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.5.0.tgz"
  sha256 "bbdd66fe00b7f52d32f1bcf6f4ab797f054630cb660a01a97478c3ad89d86e70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85d2ae64b54cd2419b7c7e46aa8107c6b0020aae5ba63942d0959a498cd35a15"
    sha256 cellar: :any,                 arm64_sequoia: "f60438f2fdf62d0baedd5f09f62d8c9ae7b326484d07ed7059f68ae3d6a9c085"
    sha256 cellar: :any,                 arm64_sonoma:  "f60438f2fdf62d0baedd5f09f62d8c9ae7b326484d07ed7059f68ae3d6a9c085"
    sha256 cellar: :any,                 sonoma:        "01423e0a5454953d4a070d734db77b4be7cce656d575ad1662356e894df2be00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06d8160e64ae05b75eabfea587a274b86a959e70c8f6da620eaa86796187f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c222612742183ba1d42e97bb98ca31de136c3e5b5f072055adf6f9f24e0e41b1"
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