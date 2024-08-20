class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags4.0.1.tar.gz"
  sha256 "8117b76b0a967887278a11470cbfa9e7aeae98f11a7eeb136f456ac462e5ba23"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0bba5ca44ee38733bd4f6b36f45b368701f7182de7acfca32180fbb7614ad69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6be520fda5b754872b7d115e30e1908d00340e9ef286eafcce0057a8fd023141"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8707a0c519d92c6f38a4fa26a82cc23ce6553d267613eecb6ab127497916541c"
    sha256 cellar: :any_skip_relocation, sonoma:         "217261ac99dde5e518f2b5d1de00b72a7043771546c404f3dc2570ab271d4600"
    sha256 cellar: :any_skip_relocation, ventura:        "dc22b663ca732bffa464bfad4c72690c8bcfb8a0572cf9e5a2b906103f0f620a"
    sha256 cellar: :any_skip_relocation, monterey:       "a32f12ddcf6ea1c81e60310387fbed1e65c5d94e52d2038d3bbde83a0d47b337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d4a5abcfd4b36d11f61d6115055d55121610f848f1c49a0e57305fafb89ad3"
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

    system ".configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share"bash-completioncompletionsbfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal ".test_file", shell_output("#{bin}bfs -name 'test*' -depth 1").chomp
  end
end