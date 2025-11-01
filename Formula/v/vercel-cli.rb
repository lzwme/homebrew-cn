class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.8.0.tgz"
  sha256 "2349f02264007c0069627b0fa3574114a7c1d9ea0af53a8d693212729011fbb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b64ff3d933ee92eca178db81b4a05a13f51cd9ce4bd68fcdbbfcfd74c5a5eac4"
    sha256 cellar: :any,                 arm64_sequoia: "aa6160fb8d1d98e08bde8d75221289f76514f3b72845229ef7af0bd8deb724c3"
    sha256 cellar: :any,                 arm64_sonoma:  "aa6160fb8d1d98e08bde8d75221289f76514f3b72845229ef7af0bd8deb724c3"
    sha256 cellar: :any,                 sonoma:        "b10641f2a728c5e38423d374f1344e302c5650f20156fb50845dc75b4ba2d315"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1c7b04d320c7a678388e7322c00e83e2db2198fb2920942d3a64d1fb543529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1266d2021454d6997a3b16b8beca935f9bef150a280fce037f5f7c7398631904"
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