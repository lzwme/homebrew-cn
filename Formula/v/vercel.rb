class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.10.0.tgz"
  sha256 "bda9b7bf6f73fa8819942cb9cc999ec0f0023e1f3a680b95b2bfd61ac7055ae0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9159a54cc19519e42aa0193bc9713c70e64b3a0150c7e749c44de23141ee034"
    sha256 cellar: :any,                 arm64_sequoia: "a9159a54cc19519e42aa0193bc9713c70e64b3a0150c7e749c44de23141ee034"
    sha256 cellar: :any,                 arm64_sonoma:  "a9159a54cc19519e42aa0193bc9713c70e64b3a0150c7e749c44de23141ee034"
    sha256 cellar: :any,                 sonoma:        "e19964a4cdaf67c239ff8c2e5d90415f1bd0fd965c2d62582d0a9cc7cb4400c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7834e6f8d95f7c80760db862a062d1cab46105cf3474a681c2bc2c09e0c079e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5401e05550ea3895b2e427c8da67e6cc69f0b5d29459d47a4893b31a8765fa2b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

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