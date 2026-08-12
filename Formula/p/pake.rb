class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.15.6.tgz"
  sha256 "3cfd9681aa737c07b7444910c3b4d88a81af7a4ac8c7d3b116a987b47bbd6483"
  license "GPL-3.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "1aa8b78520f4cf15553375165e229293016a080e6529ed86dd4f8155235fad2f"
    sha256               arm64_sequoia: "dda228e9a8496305e89ad65a8ab6a4a58f15d1cea7f2ec92eee0f980a7bf299f"
    sha256               arm64_sonoma:  "75fac1e647655b929b3b56a39d7577a9ac432a34e000a1041307fdf31d40d33e"
    sha256               sonoma:        "6fa9994c2a076809247c05be42f229f2b3e4f020f63f7dac026f89a79eabc469"
    sha256 cellar: :any, arm64_linux:   "b16db9a98a692415107917126ff03d5d777d10616640cac60f2b1a6201f0cc00"
    sha256 cellar: :any, x86_64_linux:  "b93784f448e8ae4a0f136232701cd6f988739c09e4257b652f2fa92d67392761"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.1.tgz"
    sha256 "9091c2a5e57dae6ae5a0ca9c42d6127586bed4168cc1a342c95b64e61efd60af"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.0.1.tgz"
    sha256 "455327cde805c299d5a16603419e106853db5b9257dfb85e44eb7f4ec4d99de5"
  end

  def install
    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end

    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    # `node-addon-api` 8 needs C++17, which the older `sharp` predates
    inreplace node_modules/"icon-gen/node_modules/sharp/src/binding.gyp" do |s|
      s.gsub! "'-std=c++0x'", "'-std=c++17'"
      s.gsub! "'c++11'", "'c++17'"
    end

    # `icon-gen` pins an older `sharp` whose bundled `vips` shares the brewed soname
    { node_modules => "build", node_modules/"icon-gen/node_modules" => "install" }.each do |dir, script|
      rm_r(dir.glob("@img/sharp-*/lib/*.node"))
      rm_r(dir.glob("@img/sharp-libvips-*/lib/libvips-cpp.*"))
      cd dir/"sharp" do
        system "npm", "run", script
        rm_r("src/build/Release/obj.target")
      end
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