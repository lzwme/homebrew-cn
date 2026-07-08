class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.21.0.tgz"
  sha256 "b01e3b97a7e027cacafc3e3408430663db40564abaf62d47be655573d6e0e249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6e801d2e4c9ae541b001598e1d06457739dca07031876992cf7afd26e9fe0a0"
    sha256 cellar: :any,                 arm64_sequoia: "f06c84569dedecd621ca91fe509aaf273f60b0e351b9d57bdbc7acec6e82c9bb"
    sha256 cellar: :any,                 arm64_sonoma:  "f06c84569dedecd621ca91fe509aaf273f60b0e351b9d57bdbc7acec6e82c9bb"
    sha256 cellar: :any,                 sonoma:        "a2ec1bee736cb831b2e18a754d039f7860a99c6482a67c19e1d6afb459c2abb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec0963a31cd6862cdb53b80c72ea0808b37ed403026725167070e5fc134eed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce344c87f7901c3450f952f598e4b1762719489fbb7097b3c33f39f3f785f09f"
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