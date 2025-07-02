class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.2.8.tgz"
  sha256 "55649b2493373d97d9dce0bd73d565d2d1e134a18985fc1a565fab6ea63aec17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759ed6cef3f496b985bdd048cf4e33b7969a8e3070d452e136400854ce02627b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759ed6cef3f496b985bdd048cf4e33b7969a8e3070d452e136400854ce02627b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "759ed6cef3f496b985bdd048cf4e33b7969a8e3070d452e136400854ce02627b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba233ace03590b1b6d386591c00a3b637f089071fbf0a2169ea1c71302970ce8"
    sha256 cellar: :any_skip_relocation, ventura:       "ba233ace03590b1b6d386591c00a3b637f089071fbf0a2169ea1c71302970ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c9fb1fd54b001172afdbba9be4e12736054a9aa20c354e6de2446f1e5f2dc66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba8be8b041b6c54b4e2ead79ceedbe710b22339af6ec9ce542f9da58bc2440fa"
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