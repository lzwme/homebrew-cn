class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.10.0.tgz"
  sha256 "70773d96de07cdd5bd82ba71ded6e597ffb863669078ab53c07a0cc52c64c597"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22e581a4e3383ba1e9f718cf1787b7ecce766314c01a3d036b4b75059d33d68e"
    sha256 cellar: :any,                 arm64_sequoia: "890e6640acd8331eff3ac8c3ecb95fa1d7a9fad577ec4b5a93c694bf0154fcd5"
    sha256 cellar: :any,                 arm64_sonoma:  "890e6640acd8331eff3ac8c3ecb95fa1d7a9fad577ec4b5a93c694bf0154fcd5"
    sha256 cellar: :any,                 sonoma:        "ada60913bdf6fbf2e4ca4cd252b60df7ac8b0323182d49e51f34e68fbf629a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d7c16c9940c548902878ec97d27d602261859f0d96c6aebc7e5ad49798347be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b245c079db633e252e3efb8ea41cc78d9280bdbc7c99317e4404250958c10a5"
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