class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.16.3.tgz"
  sha256 "98549d86c9f98cc5d8c1eadf6b37edb5fdb52d1eca7cc2334a5886a718508cea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72d7148d5a1008af858ae4664e7ef30eeb0affb6684da4cf7e9508926d9d26d1"
    sha256 cellar: :any, arm64_tahoe:       "466ed37a5259e41973af9db605e434b8b7efaf4e5ee8dc11af03a9e49f96c718"
    sha256 cellar: :any, arm64_sequoia:     "c802e280167223d268c9f4d2b78dd1b2f5dfc8e86bca0cf13653c8ae8962f435"
    sha256 cellar: :any, arm64_linux:       "9617f0e8b500a6c88f37d607ba44ff5a668fcf324aad4047eece7b081ba7c2ad"
    sha256 cellar: :any, x86_64_linux:      "2fc223e2323c173c2b8b8c43b148c4313739b6b5b5f91e28674fc4f88b1e9503"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.2.tgz"
    sha256 "1b1524d914331bd01312729e31a828192d53af84e113dacb6e36afabb6c21a6d"
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