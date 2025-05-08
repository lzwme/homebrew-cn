class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.3.tgz"
  sha256 "b4c6fb69535108ab5cbc8f47abe582afad9c71c9a6e06ce3aea5b18fa7e54964"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a68095f657c43135aebfec4217d8d059f1b34fd8e2cfae94854266db2f6a11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a68095f657c43135aebfec4217d8d059f1b34fd8e2cfae94854266db2f6a11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70a68095f657c43135aebfec4217d8d059f1b34fd8e2cfae94854266db2f6a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d13fab60052c5082e1aaf6a1a6da62ba5eb7e88eae739044f426021881b5297"
    sha256 cellar: :any_skip_relocation, ventura:       "2d13fab60052c5082e1aaf6a1a6da62ba5eb7e88eae739044f426021881b5297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5da41b861161393c81d1c7af9a280bcd49e6ff9cb2e02aa6c4e4137fc4983462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95056f4ed61642609f2e79b6ba79da8768a9026259e1a8c021f6edceb8ce90c0"
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