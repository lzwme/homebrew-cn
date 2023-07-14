require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.0.3.tgz"
  sha256 "4491c6aebe795a4d9deef818681801b01352f5edfbe650dd802a384f5dcd40a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b50d18745dbd89492686f612cd071bfb69dc668c73a7a79babb644297095bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfaddead9bdf9e41482e3689f5fc17cec7617faefed8ff7b0b73e4a0a4f6bad0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c64dd9b1c34089552373690bc666a02a5d7167c5b753794bdd43d0a1acdf235f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e48917a0039975e57ca1fca8b4f85457e914a8e5ce63109990feabc09ddb68"
    sha256 cellar: :any_skip_relocation, monterey:       "3d83664f76a254cefa302db55b2c0c34d94888978c8745ec96acd12151032571"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd118fa1622bf808df06d106f07125edfd2462b93c4851879238965fd3402c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07b9227e4aff5ee11224f67e929ff4e27267141fd6a5c0f21d7d690a114399e"
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