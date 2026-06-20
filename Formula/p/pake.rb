class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.10.tgz"
  sha256 "c4d06423d6be7c51eb11274dda39fe3b0eafe68c268fdd8e77fdc1507fd56fb3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa1d30cd97cc3cc60e983950776a9d49501afed844885ddfb9eb55c39d69314f"
    sha256 cellar: :any, arm64_sequoia: "aec249f8ad9d062aab8b32a9c0b9e8ad117bb9a0de0054db1cc6932d54c786c6"
    sha256 cellar: :any, arm64_sonoma:  "aec249f8ad9d062aab8b32a9c0b9e8ad117bb9a0de0054db1cc6932d54c786c6"
    sha256 cellar: :any, sonoma:        "f1ec83dba3c765d25084652261f10cda79690e05fddd16a20c55618c529b0cb8"
    sha256 cellar: :any, arm64_linux:   "fc196400b3e1d10ea51f0b06a4b67eaede4987705b532f8299b8bde637e94ddd"
    sha256 cellar: :any, x86_64_linux:  "e5a4325efaed1f920cee5641b0c58ea0b74e83681b92814d5d11ee2533a6249f"
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