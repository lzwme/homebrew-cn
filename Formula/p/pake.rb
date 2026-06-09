class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.8.tgz"
  sha256 "dda2ff9806b64ee0a8bb5aa75b6f7eb1962dbee432d26c43e7f0c1e6a37419f4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebcae7771c4cacab19f14aa752919bb8652097578dc96ccb513a5d47dffb4007"
    sha256 cellar: :any, arm64_sequoia: "412d4b9c8bcf0bc0e0dd733426544d586fc609bf3cfe88f105332d72f07549fe"
    sha256 cellar: :any, arm64_sonoma:  "412d4b9c8bcf0bc0e0dd733426544d586fc609bf3cfe88f105332d72f07549fe"
    sha256 cellar: :any, sonoma:        "5107e0007b24634988d7fdaf89a33aaefa02fb17a630ed6645074ce78a4ba6b5"
    sha256 cellar: :any, arm64_linux:   "66c68cae23d89ab746fc808b48d7cc6b44e24343730ad50ac320ac157edaceb6"
    sha256 cellar: :any, x86_64_linux:  "d282cf7d7d0a10ebce93b0618b9f2ed750b11df090d9854d0c2e1649c15edcab"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.8.0.tgz"
    sha256 "72528f1a8235a8bc19855e21cc5ae28252c276338afa73887dc7e54515bc76c5"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    rm_r(libexec.glob("#{node_modules}/icon-gen/node_modules/@img/sharp-*"))

    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    begin
      io = IO.popen("#{bin}/pake index.html --use-local-file --iterative-build --name test")
      sleep 5
    ensure
      Process.kill("TERM", io.pid)
      Process.wait(io.pid)
    end

    assert_match "No icon provided, using default icon.", io.read
  end
end