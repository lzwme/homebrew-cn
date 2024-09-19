class BcGh < Formula
  desc "Implementation of Unix dc and POSIX bc with GNU and BSD extensions"
  # The homepage is https:git.gavinhoward.comgavinbc but the Linux CI runner
  # has issues fetching the Gitea urls so we use the official GitHub mirror instead
  homepage "https:github.comgavinhowardbc"
  url "https:github.comgavinhowardbcreleasesdownload7.0.2bc-7.0.2.tar.xz"
  sha256 "5cdaa73e42deda936bdcdb668eeaa6bc0567cac820914744a6824595fa13da1d"
  license "BSD-2-Clause"
  head "https:github.comgavinhowardbc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2288ca3ec202798b306d86c1b7adaea3760b5f2288af3e4024414caf7ea07be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c0e23ca6755904f22ae926c8daa515e279e6e81f753d41363ad61e1d4dfe41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adddb6b5df7415c8bcd0b20a1d74b9bd1d6760ed9d86c64f0d66a3da565c20ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "78ba3c56b7820c163194dadc862a04f293bb4ab788c913e3cb67a74ded43e51a"
    sha256 cellar: :any_skip_relocation, ventura:       "3a0bd765df0e8cf1aff61c83d7b42ae1bb8c098c658db5e2a914fd2eb46e6a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be6bd16a61c60f59c0e6d5dd2e765bf1fe81d0140eb476646bbce18c99802c90"
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