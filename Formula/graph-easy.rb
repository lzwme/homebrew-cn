# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class GraphEasy < Formula
  desc ""
  homepage "https://metacpan.org/pod/graph-easy"
  url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Graph-Easy-0.76.tar.gz"
  sha256 "d4a2c10aebef663b598ea37f3aa3e3b752acf1fbbb961232c3dbe1155008d1fa"
  license ""

  uses_from_macos "perl"

  # Additional dependency
  # resource "" do
  #   url ""
  #   sha256 ""
  # end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    # Stage additional dependency (Makefile.PL style)
    # resource("").stage do
    #   system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    #   system "make"
    #   system "make", "install"
    # end

    # Stage additional dependency (Build.PL style)
    # resource("").stage do
    #   system "perl", "Build.PL", "--install_base", libexec
    #   system "./Build"
    #   system "./Build", "install"
    # end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"
    # bin.install name
    # bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    (bin/"graph-easy").write_env_script libexec/"bin/graph-easy", PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test graph-easy`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end