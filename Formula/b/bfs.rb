class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://ghfast.top/https://github.com/tavianator/bfs/archive/refs/tags/4.1.tar.gz"
  sha256 "7a2ccafc87803b6c42009019e0786cb1307f492c2d61d2fcb0be5dcfdd0049da"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aadf6aafb2157e623ea5b9539a4637bb229fd3427618b357213b7d3f4ba54f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bafc6e78ea498a85176fef6888a9b7547f5d0fa40e062c720fa64e23441a02c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c64ff0d5f0c72fe66c653025681fedde899c784e73e29104374fcdcee59407"
    sha256 cellar: :any_skip_relocation, sonoma:        "e51eef96a9f30866e61bc75f2e596a382e00a8746b4f9321bc8dcd15b3ee5730"
    sha256 cellar: :any_skip_relocation, ventura:       "d3d4274b53deee53fca22fb85afba3c1f5c7ebd7ed7a5c61334cdbb78d26664d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "940a33970935154d7cf1c7e12780f74090a7d4385c54e05b06e87aebd6784fc8"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "./configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share/"bash-completion/completions/bfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end