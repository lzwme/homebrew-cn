class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.7.tgz"
  sha256 "e01632f21370f46e22f3df4f5b9003c57faff9f4c6e1fc75fb3a1689e0f17bfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda46645c13f0f1234c78ed5d9b6da0816edf5b363ac31a56c10e298c0eedeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda46645c13f0f1234c78ed5d9b6da0816edf5b363ac31a56c10e298c0eedeb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda46645c13f0f1234c78ed5d9b6da0816edf5b363ac31a56c10e298c0eedeb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e28c69d262b7a97debebfee25f517449bd46edf716156ed6262b01396e2b587"
    sha256 cellar: :any_skip_relocation, ventura:       "0e28c69d262b7a97debebfee25f517449bd46edf716156ed6262b01396e2b587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c92bd142f64f8af22c4cba8fa76cc1e8b937e17b4483ce2f5879e6aeedc876df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d6741510ffd430aaaaf37600bc260ff1915500df96338eefdf07625a5eccad"
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