class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.4.3.tgz"
  sha256 "7be01ee3ff87385b515113f8a78636e9c2e3d5cb91ca29f307f707e7c995032e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8693a57f85287a2a53182f0539fdd2f7a580a4239dbe614a9db521683010fc43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8693a57f85287a2a53182f0539fdd2f7a580a4239dbe614a9db521683010fc43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8693a57f85287a2a53182f0539fdd2f7a580a4239dbe614a9db521683010fc43"
    sha256 cellar: :any_skip_relocation, sonoma:        "5243b6b1eaf7190a3da740c085c95d4cdd38988b636947d53f16a8635291dc60"
    sha256 cellar: :any_skip_relocation, ventura:       "5243b6b1eaf7190a3da740c085c95d4cdd38988b636947d53f16a8635291dc60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc9d9f53c8a5118a5f6567c309a265799cecf28be7280c20811bc3540da3bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08387e9400097f6ee702efcb669e5790e5344f3e1d931d4dd5c90875eed2906a"
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