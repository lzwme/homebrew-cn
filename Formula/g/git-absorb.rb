class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https:github.comtummychowgit-absorb"
  url "https:github.comtummychowgit-absorbarchiverefstags0.6.16.tar.gz"
  sha256 "d0fac448801674a4d4d5d42d6ef2d2e21545ad66755023c531a273a47893a573"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "678f0567eda10a1341972c676ad3c9433269609d5d8aeb03d2d899b015b85df2"
    sha256 cellar: :any,                 arm64_sonoma:  "674145b9573fccdc080a3e61435cfe4e49f7ad939c48f58759ab088b3ce4decb"
    sha256 cellar: :any,                 arm64_ventura: "dda96ef119e6eabfe891707e7c049f0abb5ff6d9de1014597cc51ef5fa36febe"
    sha256 cellar: :any,                 sonoma:        "aeaf6c2d75dd48a3eef2595dceec1edefbd7724e9ccf9e1acbaf7ae48ac6e65a"
    sha256 cellar: :any,                 ventura:       "b7e617d3c205794b774a5ae137467e67ff1539f327ebedc1de287ad68b677e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0821ca7fbac6b09e07df65c0f8e74a3a5f04f5ddbbe1fa87eb5de0f3ca0327c5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  # patch to use libgit2 1.9, upstream pr ref, https:github.comtummychowgit-absorbpull138
  patch do
    url "https:github.comtummychowgit-absorbcommita7d5688f426490a92b5bb73e3a2cfccc565747f8.patch?full_index=1"
    sha256 "cb6bf13ec90de7c434addf1467a259537d9a993f5d2481e6cba86b3543d38eed"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "Documentationgit-absorb.1"
    generate_completions_from_executable(bin"git-absorb", "--gen-completions")
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath"test").delete
    (testpath"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"

    linkage_with_libgit2 = (bin"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end