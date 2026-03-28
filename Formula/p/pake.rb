class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.0.tgz"
  sha256 "5c7642a7fe198e9e015033c85936f4cbfe835131c8e1950861a5e10e63389565"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "587ed85a716258ddba389536f771fa88d7e7ee3e4e1142c719e37d8d70a66f8f"
    sha256 cellar: :any,                 arm64_sequoia: "bc15c4349d69242d25c4304d2cc3cd60b99596484ad8d20bc6d444097ac92d20"
    sha256 cellar: :any,                 arm64_sonoma:  "bc15c4349d69242d25c4304d2cc3cd60b99596484ad8d20bc6d444097ac92d20"
    sha256 cellar: :any,                 sonoma:        "c4e651e04ef736f821135f0c26fc4ceb9ea8f74340782a6f33de62fa23852589"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afb8f2fa61a20be33e726991fc626de24c384799b4b821cf0cffde94ffec848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d387308e54b3c7eb3966d69c0eca3be67bbc7a0ec1c29db3f8c0f5f02c3331"
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