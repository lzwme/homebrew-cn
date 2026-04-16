class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.2.1.tgz"
  sha256 "e4aeb47f0457824a065b386687d0e9b4e1cbf610e6ba1a0e1b9b1cfeba55e818"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e11da3434bd3942d4b54ca8732052f2c7664d825b0107ed319db623a3a6cf365"
    sha256 cellar: :any,                 arm64_sequoia: "a71f02c0182cf54d0542f4c043346eaa7c518a5d34559d6c9ca46b1ffb2e22b2"
    sha256 cellar: :any,                 arm64_sonoma:  "a71f02c0182cf54d0542f4c043346eaa7c518a5d34559d6c9ca46b1ffb2e22b2"
    sha256 cellar: :any,                 sonoma:        "2bf9c804d857e8afb443489f114ffaf5a9643be226ab2e846d203fef0f43e97a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b98cfacd13446653689dce21a8faa7009b4d4bfe4f2bd344f9ff8a926d5be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace8cdf2dbb831b100ef2945f414012bf660bb0b11cda069951fb0a2c2a32185"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end