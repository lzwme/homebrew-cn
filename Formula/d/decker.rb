class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://ghfast.top/https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.71.tar.gz"
  sha256 "1c7907f88bb1cb47f25e12110162198d4fc8947b8046bd98317a526d416073e5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "431591185be514812c166c5cac9a46fc6ac37982c00e5dc067b83baef7f9ffbd"
    sha256 cellar: :any, arm64_tahoe:       "5d0e6b02af4fc0535a70aac59185ef0b7ed415b4bdce60aa702282606228c552"
    sha256 cellar: :any, arm64_sequoia:     "403717f836caa0bb771aca43cbac26ffcc9010513199588580ce26b41024a61b"
    sha256 cellar: :any, arm64_linux:       "dc3c87ffbdfcfc46827ac32e1314bac885c933f0ef664f86f0a93f29666a09df"
    sha256 cellar: :any, x86_64_linux:      "41bd4135572bfdfa86e55775705a2e311668bc1e80b0a33de4f6a0300a1cc5bc"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "vim" => :build # uses xxd
  end

  def install
    extra_flags = "-I#{HOMEBREW_PREFIX}/include/SDL2"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "lilt"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "decker"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    assert_match '"depth":', shell_output("#{bin}/lilt #{pkgshare}/examples/lilt/mandel.lil")
  end
end