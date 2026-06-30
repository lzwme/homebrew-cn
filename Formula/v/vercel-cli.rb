class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.2.tgz"
  sha256 "6ae86b648df1cb0a3a2331cb3a5bc813731e11dba5aebf1487950c0874bff847"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46e5668bb381732c2ada39c15c02b021ac5f45179ac4dea8f1ea2d6f0a582ab3"
    sha256 cellar: :any,                 arm64_sequoia: "a0f98aaaafa93ffc99a56392feea44e344015ba690c3a491be5137bc995969f7"
    sha256 cellar: :any,                 arm64_sonoma:  "a0f98aaaafa93ffc99a56392feea44e344015ba690c3a491be5137bc995969f7"
    sha256 cellar: :any,                 sonoma:        "fa2e94982179e62a781997f689dae355e9abffc2a3823ef7167c41d9cce41984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4388e3c05f313f4ed58360445c0f964f1f601300b499eb8bcd9c83baceafaff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f4afd6a5c762563724301fa58e1f55e44e37ec38e0309f695fd9f1af105f3b"
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