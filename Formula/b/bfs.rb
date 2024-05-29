class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags3.3.tar.gz"
  sha256 "4d3e1e48e99c3a7448c592848f39f19282d8fd2e4da5786a32ad0627ef94766e"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20dd2370121226c6c760f1878ed0d8b0dbe9f3a9a4f3f0f0527e341dddb7b87e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42351d4f799759f46eeafb9caf2aa1346e3553102f4728e0de87ff0f3f5e6f58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7758dad26d43ea18d69d3f67306eb3708e72e0190a3a51ffeed8f245199a6a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "836db9c9913b4159d0c5f4fc601ed99854ca2ec006a5c8acd18c9244a8a06198"
    sha256 cellar: :any_skip_relocation, ventura:        "f37d4f08a80b03dd5f36d66e75923f79ac886a82b119a8c5f345335f32b6028c"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4eaa9a2d68f2bc3cb3dd24ecae53530a5e2430a4a7e5b768aa8d1dd06f566a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af6e6a953351f646254a9e48c755d8aa28cd875944d446ccf24d9170862c8402"
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