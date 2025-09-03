class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-47.0.1.tgz"
  sha256 "78486c56779086eadfdde5dff67b8c75246467c23f968d6ba84c08d85283de07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca68a739837b147cbcce72cff0c26dd3d3bbb4c1aec53c2794669ecb21fa3f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca68a739837b147cbcce72cff0c26dd3d3bbb4c1aec53c2794669ecb21fa3f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca68a739837b147cbcce72cff0c26dd3d3bbb4c1aec53c2794669ecb21fa3f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd9e4fa59d72159f68a30f78e4d6fc916931d8058b786565880fcbf24453846f"
    sha256 cellar: :any_skip_relocation, ventura:       "bd9e4fa59d72159f68a30f78e4d6fc916931d8058b786565880fcbf24453846f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58e380aa7e950258fdde04e06e05e81abaf124941d0226ca6bcdc1e76fa1c548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da77592d3c4859221afcf20b23b003c053ba94157363fdf57723f7ed7540fb4c"
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