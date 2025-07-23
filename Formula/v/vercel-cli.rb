class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.5.2.tgz"
  sha256 "74faabd415cbba919621ad85b5f74775755fdd208e0cf4d18e4c16370186a2d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a9002405f9a79ce0e6494d1cafda80e5b04165f1f3d592a747509126e5ba8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a9002405f9a79ce0e6494d1cafda80e5b04165f1f3d592a747509126e5ba8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7a9002405f9a79ce0e6494d1cafda80e5b04165f1f3d592a747509126e5ba8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cae121a2870fa20e22f828a4994dd4f82cc91cd161f51139b4435f7ccc7519c6"
    sha256 cellar: :any_skip_relocation, ventura:       "cae121a2870fa20e22f828a4994dd4f82cc91cd161f51139b4435f7ccc7519c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f883956ef76ea8c7237d68835157f71018c01903c92b1f34622b1afdfa993ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107002e5d66c1896e4b54d958ec84dea802776b91137a539a42c49d47c773e8a"
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