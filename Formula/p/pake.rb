class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.1.tgz"
  sha256 "643425d7d9645f3326093f3a7cdf8f04efca402d76acf9183e5f5bb9607750f6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9d5f1976801a96774ffaf9e4e01c5b819defedacaa202b56944f641b78c55ba7"
    sha256 cellar: :any, arm64_sequoia: "9d5f1976801a96774ffaf9e4e01c5b819defedacaa202b56944f641b78c55ba7"
    sha256 cellar: :any, arm64_sonoma:  "9d5f1976801a96774ffaf9e4e01c5b819defedacaa202b56944f641b78c55ba7"
    sha256 cellar: :any, sonoma:        "7e5a9f81080d35d0a627092d8e46cfb413ef90e7101ec7df75bcafd411674dd2"
    sha256 cellar: :any, arm64_linux:   "1015c5903d6f34e9ad6246af847bb7ee5a37068fb90792d4ff0b14a1dcb08127"
    sha256 cellar: :any, x86_64_linux:  "19963e5618223f31c3a3e0181204dfcc2cb42a44cf67ddb3f3a9903091e5b61b"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.0.tgz"
    sha256 "19b87e2ce3a77fec0121ac97d7db088aae28aacfff481adab50d5f61b70e68f4"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
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