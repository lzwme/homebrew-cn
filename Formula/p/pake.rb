class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.17.3.tgz"
  sha256 "53a7db4987d99d8f6b93a2961c4a963428a20f4eb7cd49140547b20373eb5e0b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3d41e7f593a3d3e0a6ab60c6f54d57be27259b904060fb812ca66ed12f1976a"
    sha256 cellar: :any, arm64_tahoe:       "f6274b90742b92aa1f7d0dc44947d21733e7ab8baf9ae7292f69c0934bbef1b9"
    sha256 cellar: :any, arm64_sequoia:     "8a2e125366b652fc7b48b5a55ab5dccfa377a941863af5b1fa63cda724c09f06"
    sha256 cellar: :any, arm64_linux:       "817239292518b09ba5db98d83b2cc52b4c331cb0ca558b61e3d5e7bf1cd81c7a"
    sha256 cellar: :any, x86_64_linux:      "790150a058d691672f5e60f3c5d36c2f68c44e9a0957e39f1936b035720b2b86"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"
  end

  def install
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    # `sharp` ships prebuilds whose bundled `vips` shares the brewed soname
    rm_r(node_modules.glob("@img/sharp-*/lib/*.node"))
    rm_r(node_modules.glob("@img/sharp-libvips-*/lib/libvips-cpp.*"))
    cd node_modules/"sharp" do
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    # `brew test` runs with the keg read-only, but Pake creates its build cache
    # lock in Cargo's target directory before it does anything else.
    ENV["CARGO_TARGET_DIR"] = testpath/"target"

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