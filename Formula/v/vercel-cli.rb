class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.2.0.tgz"
  sha256 "96bcf59dcd13fc7f2337b7b8e1f5e60b83122fb6372ff3a641a17b5c326989cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23f6a460881524e73dd0fa692ed5c23b8654eaba22e9522394d8069d8ba437c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f6a460881524e73dd0fa692ed5c23b8654eaba22e9522394d8069d8ba437c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23f6a460881524e73dd0fa692ed5c23b8654eaba22e9522394d8069d8ba437c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "999bc8d4f79b5846cacd191dc523198e67607e7e489200f2cf61bf9b1c7cbdb7"
    sha256 cellar: :any_skip_relocation, ventura:       "999bc8d4f79b5846cacd191dc523198e67607e7e489200f2cf61bf9b1c7cbdb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00bddc99026240246900f66d9c20c873ba22a8fa61c15ac22aebaa595f624727"
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