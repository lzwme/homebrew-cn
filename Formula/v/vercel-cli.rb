class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-46.0.5.tgz"
  sha256 "94b33b188c148853408b9667508b250e463c6cb7cba415e4f504f3b4e39e8b73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6af4cd3f9e66c12d41529320be7df6a833607e346d41778b8bf2d06f8158f94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6af4cd3f9e66c12d41529320be7df6a833607e346d41778b8bf2d06f8158f94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6af4cd3f9e66c12d41529320be7df6a833607e346d41778b8bf2d06f8158f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "23a99264866347573e1196cea08571f2b2a2d547bbebf6e0712d654cf43fd0d1"
    sha256 cellar: :any_skip_relocation, ventura:       "23a99264866347573e1196cea08571f2b2a2d547bbebf6e0712d654cf43fd0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30030f63efde7abc906203b0b04ba8f285580e5dd366ac8ea23b99e8624c299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eca6e8f9415766fb6af5aaeb87c39118b872e7137cbacf637c3fac948789069"
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