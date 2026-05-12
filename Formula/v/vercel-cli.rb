class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.3.2.tgz"
  sha256 "ad2786bcec378f5cbd14b8536d8a4f05b3676c102cf3fc42a65f1448f8c227c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf99a19e82648e3f2c3e3d0eb3363091e4ede34694c56143ff7158c9a3181e33"
    sha256 cellar: :any,                 arm64_sequoia: "a7fcd9164dcd87366acb4835620a0797bd89e63718d9cea0f2d10c175b95fa80"
    sha256 cellar: :any,                 arm64_sonoma:  "a7fcd9164dcd87366acb4835620a0797bd89e63718d9cea0f2d10c175b95fa80"
    sha256 cellar: :any,                 sonoma:        "25053d5f6ceff47dbd284469ea57dd84b1fc76bc1f92951442526aeab4c66e2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e954aa55b0043947371ca07c74e8ff42826dd7a18c906f0e080170a9a85b150d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "112da7116cd91d9c887789a9e16ce925a1beb0001ebf4e9f3dc59a43cad24aeb"
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