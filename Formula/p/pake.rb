class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.8.1.tgz"
  sha256 "091c911dc37a506de9fad6e83b72a01bdc86897276a633e2d3a2d107f7a85ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17fdcf6ffbf60839f761cc207189bb26eed54354533e33bf9bf3a4db633941dd"
    sha256 cellar: :any,                 arm64_sequoia: "00a103d8f00a2f66fa3e430fad00663ebc3079eb2f17b0fae6f04a17862a7025"
    sha256 cellar: :any,                 arm64_sonoma:  "00a103d8f00a2f66fa3e430fad00663ebc3079eb2f17b0fae6f04a17862a7025"
    sha256 cellar: :any,                 sonoma:        "48aaab8cb265670bbeda5a3f9cc8636a7e1be70a0ee864ca2b956d8dddc69d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cb366f6e353fdd3ab0b9f21578fd735ee9da7984d1a0bbea256f6936ac82fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abdc364955eb4a44cf58163be506bdf037e09ea4969f171ebc63e683df36665"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.1.0.tgz"
    sha256 "492bca8e813411386e61e488f95b375262aa8f262e6e8b20d162e26bdf025f16"
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