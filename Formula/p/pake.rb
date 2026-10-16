class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.17.5.tgz"
  sha256 "cf4d75d59a64e0f3e0f6fa9e8546767cf8ca71e3222c8d4b6183eebef15fa391"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e039f3fd8de63534c653492c716ad77e785eadc1cc52c16a96a63f4a6160fea1"
    sha256 cellar: :any, arm64_tahoe:       "d174626aa4c3c9681bb1a312d65ff5a3172cb02bd4e9273fde9d7e8838cb3285"
    sha256 cellar: :any, arm64_sequoia:     "6e5ca2389370729f7578bf7bef6759919e81099c88320a8f0fc9fc550b93acf9"
    sha256 cellar: :any, arm64_linux:       "5eaf343b4d67b847bf13b1bc4a2451983db47b84449d2b6b6389b39d08cf4bbc"
    sha256 cellar: :any, x86_64_linux:      "7a3ae79e352240f2da7ca0e0aa1a20c7269a0c3074f44ab520de4140f532b105"
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