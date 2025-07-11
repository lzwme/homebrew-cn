class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.4.0.tgz"
  sha256 "3f13dee912c45cf909ae4d35e721f8ef0ce1134da49a1fc5f54a447b386cdc82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe346d2c74cfc9d95af1ac65547445bcd3f103b837f8143e79d05029729146d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe346d2c74cfc9d95af1ac65547445bcd3f103b837f8143e79d05029729146d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fe346d2c74cfc9d95af1ac65547445bcd3f103b837f8143e79d05029729146d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1828845c1e00e86682c8aa9050b7360d5ea818dd56a50cb068ab098bf7dd4f88"
    sha256 cellar: :any_skip_relocation, ventura:       "1828845c1e00e86682c8aa9050b7360d5ea818dd56a50cb068ab098bf7dd4f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961debd0c6d2d9ef77e7c50c9295b258516805b6be72dc3b9e9cbaabe1ca19de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6548266dc5c92f0b992cc3b3ce6dbab20743e6fa9b7ca718e87825fca98ce1e"
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