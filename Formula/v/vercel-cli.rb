class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.10.tgz"
  sha256 "b89e62729348b92a9d110b25456b2f4641d5d7dbc679ccd4e516ccd747d01138"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e427ba8437610d8553cdcccdcaf2b8a4280b5a8461bf7e50ba0437d15fe1c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e427ba8437610d8553cdcccdcaf2b8a4280b5a8461bf7e50ba0437d15fe1c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e427ba8437610d8553cdcccdcaf2b8a4280b5a8461bf7e50ba0437d15fe1c1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "55178179180ca3f8c5b84a449fdc8b07aaddec6e60a8d10e2e3cc418be6e6d4b"
    sha256 cellar: :any_skip_relocation, ventura:       "55178179180ca3f8c5b84a449fdc8b07aaddec6e60a8d10e2e3cc418be6e6d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac18509e5e642da0121b04a619e973595464b3f16358e64e97df38c41886831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19d7e268165db361e702de9bd56be6901fe3ea28f1fe791b2de1767b3f6dad88"
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