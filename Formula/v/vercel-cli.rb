class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.0.0.tgz"
  sha256 "8a8e717ef4aba3db753998fdd8080fa8aec622a2187a0259e5f255b5e131852f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "404810f5ff2dbaefed16e237577f18359b42fc4e6385a6340535d2ce5bce9861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404810f5ff2dbaefed16e237577f18359b42fc4e6385a6340535d2ce5bce9861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "404810f5ff2dbaefed16e237577f18359b42fc4e6385a6340535d2ce5bce9861"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebbc9ac0c61dd4526b4daffa100b2035727e7df4a28d6340262fd77adf44982f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da1ce7d6d8917cd275450235b7a032fc42f727106caf474382aff7bd0167b9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3627df191ec2324d924e1a4298e5fdb3db3b0651093963e4fa03c5deebc703bd"
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