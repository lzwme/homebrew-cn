require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.8.tgz"
  sha256 "aaa9e834077719ef0e915af6da5269666bd084c939c6c2ca0b95ec38fa417a32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b8a7d0c8583b9be18f9d2ac2ee207e16d4c44d44a4bca734336e5d4ba317f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b8a7d0c8583b9be18f9d2ac2ee207e16d4c44d44a4bca734336e5d4ba317f3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b8a7d0c8583b9be18f9d2ac2ee207e16d4c44d44a4bca734336e5d4ba317f3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f22868d380f1395459bbfda0ba5641a2fbd52074a74cd0aa146fa3c9e74fb3c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f22868d380f1395459bbfda0ba5641a2fbd52074a74cd0aa146fa3c9e74fb3c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f22868d380f1395459bbfda0ba5641a2fbd52074a74cd0aa146fa3c9e74fb3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8ef24e9bb92afe5c6c01bbfae2db83d8ca59f32ab25311baf470ea1e472398"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end