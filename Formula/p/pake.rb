class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.4.tgz"
  sha256 "c158c902b3a758d7441ad88f33f7e897034626c12016eff9ed3ce70338a27d58"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9f4079e19563c780357b43a2c4c055dbb049698065d2b17f9384ede49fad973"
    sha256 cellar: :any, arm64_sequoia: "f9f4079e19563c780357b43a2c4c055dbb049698065d2b17f9384ede49fad973"
    sha256 cellar: :any, arm64_sonoma:  "f9f4079e19563c780357b43a2c4c055dbb049698065d2b17f9384ede49fad973"
    sha256 cellar: :any, sonoma:        "b2e715b2f807b6b76465e2b28eee7b913af358a533286af57ded82e0a2803608"
    sha256 cellar: :any, arm64_linux:   "46239b92042d1c60b593e925a2b1f1908882e21a3dcd7b6e6f47c10549caf1ca"
    sha256 cellar: :any, x86_64_linux:  "22684a0dfcbce0135bb530a3e833fdc6091d486a5cc643e0f70823fd151b911a"
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