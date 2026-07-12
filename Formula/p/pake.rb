class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.14.0.tgz"
  sha256 "9a06c8d383a989306cbe8d52cdcaa62ae71d3b4df8458bbff38ccc2b6cd37174"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09b4f19e8774650c75229dc75469fa7e24f65a685f272acc918ffa37acf5ccfe"
    sha256 cellar: :any, arm64_sequoia: "6dcdb4d230762bde4b71d120a3fb52ef52d745b165099cb44fd30dba756e867f"
    sha256 cellar: :any, arm64_sonoma:  "6dcdb4d230762bde4b71d120a3fb52ef52d745b165099cb44fd30dba756e867f"
    sha256 cellar: :any, sonoma:        "16f10fd8c10a83bb64f1326d7877a31e765d42f54ae0a7689ff8f036a28396e4"
    sha256 cellar: :any, arm64_linux:   "0bb95e674b5c4252104c3e2a4a3df78f06fa0e515b014bfba1971b8da45b8707"
    sha256 cellar: :any, x86_64_linux:  "800608265e08d910128f0061d29111d7d9dde7039122f8a406aabdc12a5d3432"
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