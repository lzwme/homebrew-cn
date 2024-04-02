class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20240322.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20240322.tar.bz2"
  sha256 "0b17029a203dabf7ba6ca7e52c2d3910fff46b2979476e12a9110920b79e6a95"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "edb8aaa82c0eb53277f2399a2e9e56ec5633c4879f4827f84977cbd2cc2aa641"
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