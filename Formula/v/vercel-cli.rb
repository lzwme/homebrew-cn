class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.3.0.tgz"
  sha256 "fcc082a8900439ffc430c54e6c3faefa0d040cdfe14ab0e5033c1e1b22021b59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80119e92b593310663ebddd1f7dc798ed4eb43d409e2cac97bcfddd26682a15d"
    sha256 cellar: :any,                 arm64_sequoia: "80119e92b593310663ebddd1f7dc798ed4eb43d409e2cac97bcfddd26682a15d"
    sha256 cellar: :any,                 arm64_sonoma:  "80119e92b593310663ebddd1f7dc798ed4eb43d409e2cac97bcfddd26682a15d"
    sha256 cellar: :any,                 sonoma:        "c11b747ac1b018f1a3dd17336aa1657867bc9ae55be6ec2adf0179a10d3a3d24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8769d32c63ad06cd84fa06945ec1430abc79589dc5df49d508a8b475855be964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00426c2ee871c48d443189b11cc8546c6419c1b41e95c051e601ddd08d644316"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

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