class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20240622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20240622.tar.bz2"
  sha256 "37e210c907bd443c7d5b626071e815dc0d691d0652992b67d0c2acc34cbf38d5"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, ventura:        "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, monterey:       "e4cba90fdb5ba15d44ae8ce5db63f33060a0dc604b050661c0e1db5346f04276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e552c25a556a149172ff09f9733a5ccba5cc27c2074bcbae2128a615a0cbbb79"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    ENV.append_path "PATH", bin

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install share/"bash-completion/completions/parallel"

    inreplace_files = [
      bin/"parallel",
      doc/"parallel.texi",
      doc/"parallel_design.texi",
      doc/"parallel_examples.texi",
      man1/"parallel.1",
      man7/"parallel_design.7",
      man7/"parallel_examples.7",
    ]

    # Ignore `inreplace` failures when building from HEAD or not building a bottle.
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, build.stable? && build.bottle?
  end

  def caveats
    <<~EOS
      To use the --csv option, the Perl Text::CSV module has to be installed.
      You can install it via:
        perl -MCPAN -e'install Text::CSV'
    EOS
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end