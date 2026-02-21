class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.7.tgz"
  sha256 "e1545d9f9fcac3f48b0fbb930ebf96ab75fb32fe9e220b92b62c90c59b9849f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d7f1123b2213f786001738fc657573e36842a759034672ad3e40acc8f7b9f81"
    sha256 cellar: :any,                 arm64_sequoia: "021d0b0f118599a8c579318ba03a75c59bdeea3618e62bd33c2c27a777e92533"
    sha256 cellar: :any,                 arm64_sonoma:  "021d0b0f118599a8c579318ba03a75c59bdeea3618e62bd33c2c27a777e92533"
    sha256 cellar: :any,                 sonoma:        "90f34b7edec9ab0759b38ed9f670289d09e562a88748cac661c5f3d09b6942be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a162302ad4b91678e2105127f9abc7605ff34696f6ba91ad7788005de5a6fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f2c541a741f2e34c0d0e8c3398d1f99798a7fc620070465c1746ce6c018aac"
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