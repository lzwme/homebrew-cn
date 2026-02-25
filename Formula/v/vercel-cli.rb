class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.23.2.tgz"
  sha256 "dd312e87eab119c6730c67da166b2afe5912c303df267c13a70034ffecfe3ba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7b73928c70689e60835a4c8f17806913e7fdd997ec690e59d8c8f22c6db6419"
    sha256 cellar: :any,                 arm64_sequoia: "8678d30b458c9db05839b98fe0b666154f4172f4fffa73100905214ec2b67630"
    sha256 cellar: :any,                 arm64_sonoma:  "06e608f90066fb0b2080f9fbc945f46c4ddb5649803139f4b8b7720879b58f7a"
    sha256 cellar: :any,                 sonoma:        "0014cc2d9aeb55c3d3c8570405d53cb619aa9f15764647b25f8d83e793aa89f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3878a80d3c316295844ad6c3e9fdcf2c023e50e9e51bcfefc98817186e7055b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70568189a3971a3c84562827d4756e3692620c48ae0b503e9df09c4ab1f1d5a2"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end