class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.9.tgz"
  sha256 "c226050ad6f075871b220b3528a6d958ddc2a461dc7d05973d045cdafbd906a4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78ca731aa87b5e457a32dbffcf79c47bc87e31223941292237cd7da996abfb60"
    sha256 cellar: :any, arm64_sequoia: "fe6b02ef6bcaac9f2dd002ea14770e2e5c7f1b42c1573188927c666cadfeb030"
    sha256 cellar: :any, arm64_sonoma:  "fe6b02ef6bcaac9f2dd002ea14770e2e5c7f1b42c1573188927c666cadfeb030"
    sha256 cellar: :any, sonoma:        "bfaf82c8a06f5675f56d60d997f339aa28bf1ed83eeb62b41d01daee468ca5f5"
    sha256 cellar: :any, arm64_linux:   "0cf6da00ec9699277d3420b69c332c9086d84c71d087e89de0622ae9dba081c5"
    sha256 cellar: :any, x86_64_linux:  "41cadc8ffed8dd834565b40d48bf7bff277a47092f6a38723dccdceb92fadb0a"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"
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