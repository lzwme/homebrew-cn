class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.22.1.tgz"
  sha256 "3dec7df530b44e5fd449e9bcc3237b400d475a9d485ec1b07a22763cd25af0e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "106ec491f88438e6a1c21076cca05fc3683b6dfbe0601242bcb9524089f128ee"
    sha256 cellar: :any,                 arm64_sequoia: "f326831414d66634ef8c09afda29f3b3bf5c86da1e8778fc93993919041bbe14"
    sha256 cellar: :any,                 arm64_sonoma:  "f326831414d66634ef8c09afda29f3b3bf5c86da1e8778fc93993919041bbe14"
    sha256 cellar: :any,                 sonoma:        "10992cfd3dcd4469c3748efc1240d479dd65cdc930f9b6edca8bd415e4253dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec5220e7e73b92bfd2178972ac03d63d5777e2d69b631f79bea7b09f76fc3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ce41ede653800b9cc30aec4c388283315fe2bf8d8af40385d42caf1bb583d6c"
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