class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.6.6.tgz"
  sha256 "ac8270ab33fb76e2d26f973fd1e03fddf1894a8fd9b34cfee2df76dab26db655"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cc893d68ac664b263946ce751e3521a2af88b3191ddfcf227d332f4e40f6871"
    sha256 cellar: :any,                 arm64_sequoia: "e186db0de8c599f23b64ceaae0b27b9de8fb54652a88bc05441da9bac0318db6"
    sha256 cellar: :any,                 arm64_sonoma:  "e186db0de8c599f23b64ceaae0b27b9de8fb54652a88bc05441da9bac0318db6"
    sha256 cellar: :any,                 sonoma:        "c896914d1a108d38f8abd4d1648eaa3f044cd7943448846cc732d6d9f9762630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dee75263c67341d5e3593145c2dfa8296514570228ab79267cc0d30ce4e75eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f951d5e9a9a19b988815da56403fa29b542c79186f38115e24c18cd2aea50ee1"
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