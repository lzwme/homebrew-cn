require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.0.0.tgz"
  sha256 "6ababac7963c6420cec90b6c11879c244859302b5461c4d5e2ca119fcec05081"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afa295fc4d4ca6066e7b92c3748afab0f1570cd6faa0c58438257ad7aebe160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "754252bb5c7f689c5b20faaa2d25430a1f873ad7a3f9e73dc85228a9d50067ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9da42d993754446f63db4c4e661684464a889322e150f3a1bd0c0fafb194495"
    sha256 cellar: :any_skip_relocation, ventura:        "2147433936e5b56477dd6fe3403d3f0791281352e59fea06d7acee34b36d7700"
    sha256 cellar: :any_skip_relocation, monterey:       "c5eb9c19f03370c40434c4c77a205d0c1c1e94d0d21c14177bacd42cc297242d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd69adb1dbe88abb697c96851da90e026ee51f88a21dc6629d2c10df287b9487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb752d06907c0ba7d4bfd3479f3e5590e6aa306e384f719f8ab5403dffeaca8a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end