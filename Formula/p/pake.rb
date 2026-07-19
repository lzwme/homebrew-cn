class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.0.tgz"
  sha256 "52f4761d0aca2ed3a6a1b5903460413691a436feab60b1693d0030548cce77d6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4759a36531d82d1d264e2fa600f54a0d8f5c1eabe597b0d4fa916bd028b07110"
    sha256 cellar: :any, arm64_sequoia: "4759a36531d82d1d264e2fa600f54a0d8f5c1eabe597b0d4fa916bd028b07110"
    sha256 cellar: :any, arm64_sonoma:  "4759a36531d82d1d264e2fa600f54a0d8f5c1eabe597b0d4fa916bd028b07110"
    sha256 cellar: :any, sonoma:        "9ebc90c097a8d816f8bc81e7e65d41f023d0042eebf5e2bdffa66d989ab813af"
    sha256 cellar: :any, arm64_linux:   "62ee2aea791718c23bcea2228925dc60b24b0ef6c6d4336b4821e7ca5a087987"
    sha256 cellar: :any, x86_64_linux:  "cfc560627fb5304767b0e01158d88330640f849693f848f37d530033c670243c"
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