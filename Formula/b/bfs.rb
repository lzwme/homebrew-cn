class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags4.0.3.tar.gz"
  sha256 "eaa5fde48f0fb62c8ef5331d80cc93dd3cd6614a7f4d28495857893c164c9ad9"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6319a3f47ff7433bf76d319f38ddc61701aae970cfeb8689eeefb8a526e360d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbbd3b9421dbf4a408506cc7212ff394833e6d4f6f963e5e1f75bf31e0c80911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae468c8a50facfda493a6b8feb1d8f6d7a2b3968ac6bf6af516f287d900e8cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e407123aa2a3cbec343bd2a0301f26f3ff4ac616cccbb4618dc629f544acb7db"
    sha256 cellar: :any_skip_relocation, ventura:       "e137dd3560f39d11d56917ec09152c982afe9c9d33b6873086e0f663cc70855a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03de4f6176c908915717e793e1f5b5a3da3ce8a19cf68ce1877714e4352e0ada"
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