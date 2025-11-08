class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.9.0.tgz"
  sha256 "f2810b69b39fcb4f972909c447781d76cd8b477153e951ed5b4d82c40435173e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16598f84520da18dc4a0adcd64380746132c368b4354c5ecbd9f0b7289f2b88d"
    sha256 cellar: :any,                 arm64_sequoia: "8d650e0597eb76910265545e16619b81de24ef98042180b3541851436d71241f"
    sha256 cellar: :any,                 arm64_sonoma:  "8d650e0597eb76910265545e16619b81de24ef98042180b3541851436d71241f"
    sha256 cellar: :any,                 sonoma:        "c79cbde9ca4a0af6ea2936f3a88ac4f955040731969a1857cd5591f1f02b427e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "506112f96bafa77e65209e47ca2c1bb7669b4510bb30637486bce9ed294721d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb743d8bf7c54ea5282b4aad6009214d848858cceb484d6f4a0a4393d29d820"
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