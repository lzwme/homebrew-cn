class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.13.0.tgz"
  sha256 "12f9316eb0cd57342904cd33135ba9e64c81fd82aee2849273e827b2efa52f4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb9c0dc7dad4357507017cb57d9c78862ee33e1a8629690f619b9c1927148f71"
    sha256 cellar: :any, arm64_sequoia: "98d82415395b10729e236001474becbf5d34a5d34a32451bc7c912960b92f49c"
    sha256 cellar: :any, arm64_sonoma:  "98d82415395b10729e236001474becbf5d34a5d34a32451bc7c912960b92f49c"
    sha256 cellar: :any, sonoma:        "905801d459f02bf34f2d59e9377c4313610a9ecd4f6a3a7a7ee6fa4513b7ee2c"
    sha256 cellar: :any, arm64_linux:   "423649b68ac2576427c0918c1d208c736d6c70fb7576dd078983060625ae02df"
    sha256 cellar: :any, x86_64_linux:  "b3a9c74e8d6e432f8e737b8099b8931b7efb7e48c4ebfe48ffad3dbdbd2aa81e"
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
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.0.tgz"
    sha256 "10e45f33997680c9ea6ebfb8c575aba66bfbe8ad9c782a7426a37440b28b62a6"
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