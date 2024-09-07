class BcGh < Formula
  desc "Implementation of Unix dc and POSIX bc with GNU and BSD extensions"
  # The homepage is https:git.gavinhoward.comgavinbc but the Linux CI runner
  # has issues fetching the Gitea urls so we use the official GitHub mirror instead
  homepage "https:github.comgavinhowardbc"
  url "https:github.comgavinhowardbcreleasesdownload7.0.1bc-7.0.1.tar.xz"
  sha256 "d6da15d968611aa3fae78b7427bd35a44afb4bdcdd9fbe6259d27ea599032fa4"
  license "BSD-2-Clause"
  head "https:github.comgavinhowardbc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab1938d31e9f9a3a0b7d11b3d07fd2af727feed4af221ce7786d228b0fe48931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "399116f8b99251e5ea0e1636c1aa3b5316e76c858fe9180a5b021ee496e5d874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c83c073b1c4eb4a4f15754e40c42335e8af1733fe4e21544fbc282c05591f59"
    sha256 cellar: :any_skip_relocation, sonoma:         "647ae5d297c7c4c9c94432c6c6dc9c988efc8289144ed6d781e203c8d4b5ac0e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b93598df94d526c9df26bbe7deb183711693d56da0ef43e43eb3b082165f0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "3d003b1d72870a1f6696897856058a048107c123a6563825eb2ef8654f63311a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b997bfb3eae62ad9b5ed7b3933602112ee53af886b7cd0011c38876c906ab9d"
  end

  # TODO: keg_only :provided_by_macos (replaced GNU bc since Ventura)
  keg_only :shadowed_by_macos

  depends_on "pkg-config" => :build

  uses_from_macos "libedit"

  # TODO: conflicts_with "bc", because: "both install `bc` and `dc` binaries"

  def install
    # https:git.gavinhoward.comgavinbc#recommended-optimizations
    ENV.O3
    ENV.append "CFLAGS", "-flto"

    # NOTE: `--predefined-build-type` should be kept first to avoid overwriting later args
    system ".configure.sh", "--predefined-build-type=GNU",
                             "--disable-generated-tests",
                             "--disable-problematic-tests",
                             "--disable-nls",
                             "--enable-editline",
                             "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin"bc", "--version"
    assert_match "2", pipe_output(bin"bc", "1+1\n")
  end
end