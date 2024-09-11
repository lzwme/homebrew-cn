class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https:github.comAlDanialcloc"
  url "https:github.comAlDanialclocarchiverefstagsv2.02.tar.gz"
  sha256 "ce436edb633a06f0ee408e858f8536d0564e8404e656767b3669eb629bf95bf8"
  license "GPL-2.0-or-later"
  head "https:github.comAlDanialcloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16542660d181d13fc91f1466d7eb10ee2fe59def1e07003219b95ea297ffb108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5c78fcf0db5b52e2909c757749f4c540f91c00d9acc539500d0497a42c0ecc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc419786fe93816ad32d5c9cb1ca8b9b746312561e63da3cb8ae023df4a6d863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc419786fe93816ad32d5c9cb1ca8b9b746312561e63da3cb8ae023df4a6d863"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c80b3d16087ac35012b01041cae6d3559b5c986fc462b147311fac34b1f67d9"
    sha256 cellar: :any_skip_relocation, ventura:        "ab94f03bef5f9bd5c921e6c31d50cba4d5c0c94447b82b7d36f04117beac363d"
    sha256 cellar: :any_skip_relocation, monterey:       "ab94f03bef5f9bd5c921e6c31d50cba4d5c0c94447b82b7d36f04117beac363d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d559760697510aa1b248cd8ba072bcaac08f46230c2b24f7f16fe2de015163"
  end

  uses_from_macos "perl"

  resource "Regexp::Common" do
    url "https:cpan.metacpan.orgauthorsidAABABIGAILRegexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Algorithm::Diff" do
    url "https:cpan.metacpan.orgauthorsidRRJRJBSAlgorithm-Diff-1.201.tar.gz"
    sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
  end

  resource "Parallel::ForkManager" do
    url "https:cpan.metacpan.orgauthorsidYYAYANICKParallel-ForkManager-2.02.tar.gz"
    sha256 "c1b2970a8bb666c3de7caac4a8f4dbcc043ab819bbc337692ec7bf27adae4404"
  end

  resource "Sub::Quote" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGSub-Quote-2.006008.tar.gz"
    sha256 "94bebd500af55762e83ea2f2bc594d87af828072370c7110c60c238a800d15b2"
  end

  resource "Moo::Role" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGMoo-2.005005.tar.gz"
    sha256 "fb5a2952649faed07373f220b78004a9c6aba387739133740c1770e9b1f4b108"
  end

  resource "Module::Runtime" do
    url "https:cpan.metacpan.orgauthorsidZZEZEFRAMModule-Runtime-0.016.tar.gz"
    sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
  end

  resource "Role::Tiny" do
    url "https:cpan.metacpan.orgauthorsidHHAHAARGRole-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Devel::GlobalDestruction" do
    on_linux do
      url "https:cpan.metacpan.orgauthorsidHHAHAARGDevel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end
  end

  resource "Sub::Exporter::Progressive" do
    on_linux do
      url "https:cpan.metacpan.orgauthorsidFFRFREWSub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    # These are shipped as standard with OS XmacOS' default Perl, but
    # because upstream has chosen to use "#!usrbinenv perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec"bincloc"
    bin.env_script_all_files(libexec"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install libexec"sharemanman1cloc.1"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}cloc --csv .")
  end
end