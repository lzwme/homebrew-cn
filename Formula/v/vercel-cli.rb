class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-49.1.1.tgz"
  sha256 "02cbe353b2ddb60abe20b5d47f224339e00528e8ced18b0f646fd737554b2879"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d4a9fdfb79b232b58e6cb0b3b2526e2091fe298bb5e6ef814c72de5c19ebc87"
    sha256 cellar: :any,                 arm64_sequoia: "12e5d4c5bb8dc104838c6a45e08b01a1b57ea9ad6f90f900577b976f1d81ed6a"
    sha256 cellar: :any,                 arm64_sonoma:  "12e5d4c5bb8dc104838c6a45e08b01a1b57ea9ad6f90f900577b976f1d81ed6a"
    sha256 cellar: :any,                 sonoma:        "978da1c5b0ecfa86b469dbfebfbaad86ea011c5d2b16fd1c7e0dc665da697cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc12a172541da6ad29969451193a841e485a7832329d03b27b90fb7abc255a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea5492ea7a1bc784a6d1389d296733edd89b704ad9039bc3c442c68076fb3f33"
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

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end