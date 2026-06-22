class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.14.5.tgz"
  sha256 "45557a3e53bc5b7cdef275859c5488f6db67fe762d9c40be3ed0eb40c844d956"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "800cd42f0568e0fb4e95472af9e18e017bb8e52800cb89d6f6060fdf04b69de0"
    sha256 cellar: :any,                 arm64_sequoia: "696692f3db7617f722426c3b71f0e7f07ca17819ce9723edac6ebad0bf250a0c"
    sha256 cellar: :any,                 arm64_sonoma:  "696692f3db7617f722426c3b71f0e7f07ca17819ce9723edac6ebad0bf250a0c"
    sha256 cellar: :any,                 sonoma:        "ca8f3234e053c1feb8d6702fd471f375b7902eb5365145c6a3e938f0267edaa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3120aea2be9d25e4c96caeb7828f08e1fc0b548829a9a7a35940344998292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5bc03e50b22b7cb5dc7119aa0f35d04a5c623929ff3a281674dd53ea1afb42"
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