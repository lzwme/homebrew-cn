class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.4.tgz"
  sha256 "1aba3678a10c225c88b612682e4f00288d490ec0f2f702173cc36a1c2d6e4ae6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79802867b0ab98f9f1db2998f6291ad92c57c02b6915554199dbde5a285a6c17"
    sha256 cellar: :any,                 arm64_sequoia: "9f0dfd181681eb8ed557128a619916db1c22fab559014c4c1640273b84839bf3"
    sha256 cellar: :any,                 arm64_sonoma:  "9f0dfd181681eb8ed557128a619916db1c22fab559014c4c1640273b84839bf3"
    sha256 cellar: :any,                 sonoma:        "28492627bad567a57aaf3defe5ee3247a1085b6df88d6a79eeeaa684efb2fd33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1972bfcb67bf17836b7add5208e684b9919e3d92ec50e94c909d9483df4da8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60839d5c46e2e8355574a5ebc14fdccc1226fef5c1f0cedb560e77d7312c4de7"
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