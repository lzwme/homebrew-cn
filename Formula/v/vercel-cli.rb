class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.7.tgz"
  sha256 "316e84877c4db7ebdde89890360190d90f0f771a87cc20e9b89a850df9322e76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "201336c546cc7b6d18673d01ea6b6654bcdd16540eb1429e4b1359cf2073032a"
    sha256 cellar: :any,                 arm64_sequoia: "83be8ca614dcac8ed58bbded1fb44034fa16c2db86b4a054fe78844493511802"
    sha256 cellar: :any,                 arm64_sonoma:  "83be8ca614dcac8ed58bbded1fb44034fa16c2db86b4a054fe78844493511802"
    sha256 cellar: :any,                 sonoma:        "bd2ec645742b4455fe636accf85a333970f91e94cbd206390d8aacebc20c8d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fde3c007887dd4d66721c165f4f55e81dd43aac01a072a05c03a9e325d9b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f644b7ce55baf790316e5805ee98124f2f86c15f49106d6d27d958c6d20434b1"
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