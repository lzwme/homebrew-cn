class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.7.4.tgz"
  sha256 "4e97f7e7ad953fca34c1e38f21417a9fc3e0725e155511e825e7aa09da51246a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c15941524330c9e1952288e8c415f2fbafd3fd686cbb47578a0627983f498cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c15941524330c9e1952288e8c415f2fbafd3fd686cbb47578a0627983f498cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c15941524330c9e1952288e8c415f2fbafd3fd686cbb47578a0627983f498cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0713c34f4ffba016543b3770f1655440c6f4aa35484ecf8830ed4c677893c8"
    sha256 cellar: :any_skip_relocation, ventura:       "bb0713c34f4ffba016543b3770f1655440c6f4aa35484ecf8830ed4c677893c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dcdc6278d27768cac9c57f7ee5c315f98a96002955a19a26b7248a574eeb457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce6d4bd8d3a9e086669e0ec7416a50e4195f99f97ee3b97f2cb11d1a41963e2"
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