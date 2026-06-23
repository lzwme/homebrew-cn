class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.12.0.tgz"
  sha256 "b49d45c199eaec18fca971856c9aae94d2672420a79d062a24085b9622e37f8d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef5a5c62bf4da2a3bc3e4d682a2f03cad58366da926e52662a8bbf426a4bf35a"
    sha256 cellar: :any, arm64_sequoia: "c512c8a0039d5c66277d9739a3df8b26d23dc14ed53b2aee5d2409a9dc23dd20"
    sha256 cellar: :any, arm64_sonoma:  "c512c8a0039d5c66277d9739a3df8b26d23dc14ed53b2aee5d2409a9dc23dd20"
    sha256 cellar: :any, sonoma:        "3272a00f00aa00f8aae67591ad6cafde2b1368c51a21e834d52be9a9e4fbbb13"
    sha256 cellar: :any, arm64_linux:   "1069b9a41299a7daecf9a581ee0212c13938756f4b173333c140790d0b459830"
    sha256 cellar: :any, x86_64_linux:  "53a7c057f051f66d06b55617dd60ec954b5316c00921706c936d10d58c58b570"
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