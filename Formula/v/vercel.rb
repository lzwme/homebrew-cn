class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.1.0.tgz"
  sha256 "afdbe2a880ed63cdbceb98c64fe10dabba67205c1740f9631efe0819c944db5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0aa18f7371a0e0cdc315a5b38aab9f9d974dcc46a6be5146b603f28a9ac411bf"
    sha256 cellar: :any,                 arm64_sequoia: "0aa18f7371a0e0cdc315a5b38aab9f9d974dcc46a6be5146b603f28a9ac411bf"
    sha256 cellar: :any,                 arm64_sonoma:  "0aa18f7371a0e0cdc315a5b38aab9f9d974dcc46a6be5146b603f28a9ac411bf"
    sha256 cellar: :any,                 sonoma:        "c0436b40f3fa75b02b454262364b389cd61b321d3dd45757b3fbb407cbc3f27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fddf258ab3008e29e9d27fd0f0f809dc5ce8784b79464910e0aa3e21ec6c06a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f232922fe81327a12bd311fe7049388d2830bcea324b2e71a28cd1ae8b359c4"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

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