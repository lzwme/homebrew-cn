class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.19.0.tgz"
  sha256 "e498e9e17b448c324861882b9cd56b749a7457e42f43ff8d021edaca2c83ae5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "667cbe800a22924d6be8dfc14e2f8ad47a0123f3f49f88ed23e00b6753d04de4"
    sha256 cellar: :any,                 arm64_sequoia: "e1d484fe365f3b5e8340775f4c23d6ec60127b473e949ac21b471eb6067908a8"
    sha256 cellar: :any,                 arm64_sonoma:  "e1d484fe365f3b5e8340775f4c23d6ec60127b473e949ac21b471eb6067908a8"
    sha256 cellar: :any,                 sonoma:        "7054831a6a7664a2bdfc9ea7dfb189b176162e3a7ae2364ac2366d58d4dc2b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e47fc429010670147ab4096bc56cce8b46587cd24b91cf36973a0284e8507f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660a91447842e56d7ca70ac8c3bef4b6809cb8b787d75183ff61674d58b7cece"
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