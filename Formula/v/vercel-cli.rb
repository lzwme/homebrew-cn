class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-55.0.0.tgz"
  sha256 "961a8917e038ac2e402f2560fdbf36f6f40d1225ab32040f989d64d223e21d7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8baa8843b3993aaace3ad097a24ffcf97e3c9c2c7cea79e3d436aa1dde8894a7"
    sha256 cellar: :any,                 arm64_sequoia: "ff00299be08f90e89227d0ccdbdadc65e92b1f4cd20e6a324a66cbb04fa919f5"
    sha256 cellar: :any,                 arm64_sonoma:  "ff00299be08f90e89227d0ccdbdadc65e92b1f4cd20e6a324a66cbb04fa919f5"
    sha256 cellar: :any,                 sonoma:        "5438783651715b8212a7875ef044aaccbc45aa5b77731e030cdf2431548ba5ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e16ee87595388434b61fa04b4f8ea060d29de2e7d5a0e5c05fbaa9bf3b28b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f716ad3b9710c92f5301df58926f0baf86dac35eb41c823fceb2108e6d6c1221"
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