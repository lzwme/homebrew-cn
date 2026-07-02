class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.6.tgz"
  sha256 "da508e41da6a3db7c2e22268ae4513575d57d72cbc744de4ed93c79dc96a4731"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6061792affb6948b3123a4fbd3f6d2c4fff978c2ab07898dcbb720bb0c9a75c6"
    sha256 cellar: :any,                 arm64_sequoia: "1e1a077e2a819ce53139e3ebe5576e643a4118d408e16b2642ab4474408c0493"
    sha256 cellar: :any,                 arm64_sonoma:  "1e1a077e2a819ce53139e3ebe5576e643a4118d408e16b2642ab4474408c0493"
    sha256 cellar: :any,                 sonoma:        "884972af2e65af07b21496264b741a790b4389eda63f04cf57db14e76a9be1c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3f53ca04d0a0020ccdc41ed9d643758ebd72fd700c1a2cf356c2c5cb096d572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0d655569ed18314aff0eb4e1d9d615947c86db88ac44a99b3b48604d9b57e0"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end