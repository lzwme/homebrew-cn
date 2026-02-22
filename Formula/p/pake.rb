class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.9.1.tgz"
  sha256 "e25fe822078ff039a67cc7767e336c34789ba0a69a868c47e58dfdf147851138"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "175c5d2eb441acce5943caf925570031a5281ea543f8f83c875cd52b53125fed"
    sha256 cellar: :any,                 arm64_sequoia: "615ccfeb7baa898ea9894dc59ce162a896a3538b6c1c67ebc992fd0798c52e8f"
    sha256 cellar: :any,                 arm64_sonoma:  "615ccfeb7baa898ea9894dc59ce162a896a3538b6c1c67ebc992fd0798c52e8f"
    sha256 cellar: :any,                 sonoma:        "47474613a239da2e1549e69493be21b14cf46ee16562f0009e72dacca7d225e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc13f5010dc2d0bce4ef2af97a71282ccd7a1facf47bbeef08b28d8a5ccde2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b54e4ba757d1710503226c50a0608d8d57cb4e08d9c3859a2f076dceeed7f4"
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