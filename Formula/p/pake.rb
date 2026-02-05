class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.3.tgz"
  sha256 "6baa6b4a4bea796635db72e160f97be666b3d54e835f036c591f40a8520171b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dcb5e0006fdd849b05602882d31969f8aef101ee17ae49bbd113bc0e81bac7f"
    sha256 cellar: :any,                 arm64_sequoia: "35bb2e70181b91e373da85cd7fad49b26838c9949930bd545ef1f69510aafcad"
    sha256 cellar: :any,                 arm64_sonoma:  "35bb2e70181b91e373da85cd7fad49b26838c9949930bd545ef1f69510aafcad"
    sha256 cellar: :any,                 sonoma:        "1992b55b6c5771b9ba39b04b8bea9613d98c3a8207bdb99ccba1c131b07527d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c63b80145fc59647eb2cd36f966f04dd9f6f01aa0acc3a65fe4a98313fe3a2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abfef6245073aa02c9f2b6dbbd8e3622f15cd329e7f5fb8ed0821286a507b2f"
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