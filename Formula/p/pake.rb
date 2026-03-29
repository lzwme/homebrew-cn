class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.1.tgz"
  sha256 "6f8d7d65bfcd276d64f37b98dc0d6f5870cf67fc5cf539031f3f15b5336d3056"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ecf06c6cae38aaed3c71bcc32d7362153185090a364ab5bbd5dc5e208197f7f"
    sha256 cellar: :any,                 arm64_sequoia: "150fd90be7f64564e3aae37f0f9d0b758599bc7678bc27e802af2f7b27c198bb"
    sha256 cellar: :any,                 arm64_sonoma:  "150fd90be7f64564e3aae37f0f9d0b758599bc7678bc27e802af2f7b27c198bb"
    sha256 cellar: :any,                 sonoma:        "69bd640a1539c8824b5ec36909aec8688ed16f61b8b868f27e761e83f633edb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084333308992eb5645411eb2964d5aa5bb5aeba7bfed1f379a85756efb940a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd335c2a904a3aad67c439ee09d7212081234a5421b97665689f2adf95a2c90c"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.6.0.tgz"
    sha256 "e3029e9581015874cc794771ec9b970be83b12c456ded15cfba9371bddc42569"
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