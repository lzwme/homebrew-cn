class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.18.0.tgz"
  sha256 "6976f171f9a21157d272be04a7a6b3c93ff862d8389ce51288e5973cabe9c6bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ced61700d6c243859ad26ee0b1318bc856be04c6ddd9dc7605cade3a6e6d60b9"
    sha256 cellar: :any,                 arm64_sequoia: "39500080d027c9b8d536e0c680b1ea5de9a90f4244e30f95e54dedcad2fb5b8a"
    sha256 cellar: :any,                 arm64_sonoma:  "39500080d027c9b8d536e0c680b1ea5de9a90f4244e30f95e54dedcad2fb5b8a"
    sha256 cellar: :any,                 sonoma:        "52d6ac1f2def19000f3f9075a124e87a6f75cba2e523e4014bd821bef5bf98f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84cea66023613374e7bb4ee4822b663ddb44fd7cb979a356c4a65100b55a3134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f30fed5fbdb576cae4604d6fd6b6329c92a85323a87abacf48fba3bbe8914a2"
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