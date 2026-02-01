class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.2.tgz"
  sha256 "e9e095d8f20d89f25f09db9254b53bd23b05109edebcec712e3ba366f5cd0ce7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "127d7f67cabc5793a9681c6f1f9268db0c8b6c9f8d70099ebafcd8608e7a2586"
    sha256 cellar: :any,                 arm64_sequoia: "0818a094bef8f5c5dc62ad3b5b808ad71e84d38dc5e7487855793685769e586e"
    sha256 cellar: :any,                 arm64_sonoma:  "0818a094bef8f5c5dc62ad3b5b808ad71e84d38dc5e7487855793685769e586e"
    sha256 cellar: :any,                 sonoma:        "03e386a7fb27f28e718ea295b44e5064c5ea5920de42b8c8d97861d47f40384c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "810760085fa32efa8a20df73762bee91a1066d017b86768317355676e15c1d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b429f37249217f28657c6ec75d07d4c1516f1d22aa2c99f709165dcafa4a01"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz"
    sha256 "d12f07c8162283b6213551855f1da8dac162331374629830b5e640f130f07910"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.2.0.tgz"
    sha256 "8689bbeb45a3219dfeb5b05a08d000d3b2492e12db02d46c81af0bee5c085fec"
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