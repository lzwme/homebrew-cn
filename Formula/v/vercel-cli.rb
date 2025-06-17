class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-43.2.0.tgz"
  sha256 "8cc495c361455a637d856e9d7c1bedfea9e831490209cce53da8fd554cd34346"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e0d37be376a08d7047f30271e8dd95b636259997a541f5634c04edab7b4a093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0d37be376a08d7047f30271e8dd95b636259997a541f5634c04edab7b4a093"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e0d37be376a08d7047f30271e8dd95b636259997a541f5634c04edab7b4a093"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be46dfb1b5d67a4bb0c66c04e0603b59d03f9ebd28f687ab0b3b40f52343aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "9be46dfb1b5d67a4bb0c66c04e0603b59d03f9ebd28f687ab0b3b40f52343aa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f619e308f7e49153f1065bf3ad0fe5741547f25bd1b971f360c68d78b3c382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90a9b56eebded9e3a9c6e25e1bf0dff4188f097d423b77ccade60f8fe61b08ee"
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