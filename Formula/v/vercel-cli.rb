class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.1.2.tgz"
  sha256 "0a99c341c38afe92f2051301cb4460543a5edf3b2108c7aad99fd0e88ec1cf13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02fd800510b0255606e988db4f870e4414f1a508a633fc0bd4c54f3db33dd76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02fd800510b0255606e988db4f870e4414f1a508a633fc0bd4c54f3db33dd76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b02fd800510b0255606e988db4f870e4414f1a508a633fc0bd4c54f3db33dd76"
    sha256 cellar: :any_skip_relocation, sonoma:        "2069fab23a4e91902853a12222e11b6437c39169f2ee763b2313a1aa4fa40701"
    sha256 cellar: :any_skip_relocation, ventura:       "2069fab23a4e91902853a12222e11b6437c39169f2ee763b2313a1aa4fa40701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d39c2addd68f6147825169ba4975c9c46ce7bf35dbaaac34d450d5791e775da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a12fcccc196e480bc893c48ef7642046e2df93777f71a24401cf9d26622c8bf"
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