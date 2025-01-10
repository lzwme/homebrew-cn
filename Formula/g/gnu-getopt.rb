class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https:github.comutil-linuxutil-linux"
  url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linuxv2.40util-linux-2.40.3.tar.xz"
  sha256 "0d6429d0cc474eafb972b0f4fee6b9c3d3f31c7bbada012bb3a1e255f00612c5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:mirrors.edge.kernel.orgpublinuxutilsutil-linux"
    regex(href=.*?util-linux[._-]v?(\d+(?:\.\d+)+)\.ti)
    strategy :page_match do |page, regex|
      # Match versions from directories
      versions = page.scan(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
                     .flatten
                     .uniq
                     .sort_by { |v| Version.new(v) }
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Fetch the page for the newest version directory
      dir_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join(@url, "v#{newest_version}").to_s,
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(regex).flatten

      dir_versions || versions
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2523f22267194e2ad829d5ab201aabd7989a43340bed1ce6d60ca92ada1c158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f08df33c27885da287e93002062193cd4ad71b638103c90fa5a0ac2d5f34b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7bf298068157dac4e9cb9dd28d4321125ef3842befaf8768a01ead95e6892c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ed676cdeb22e00f6d280c9802e99288b3799d995aceb10cffa13d9beec61a83"
    sha256 cellar: :any_skip_relocation, ventura:       "6fc4e9965fee9e69c8eb0cfe8bb0c6c8bb47f99864cd3db89539ee00ba055cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24623fde4cf0fa3643118d179b18ea39e489e4a2934b17a7462c0fea7085f71e"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD getopt"

  on_linux do
    keg_only "it conflicts with util-linux"
  end

  def install
    system ".configure", "--disable-silent-rules",
                          "--disable-liblastlog2",
                          *std_configure_args

    system "make", "getopt", "misc-utilsgetopt.1"

    bin.install "getopt"
    man1.install "misc-utilsgetopt.1"
    bash_completion.install "bash-completiongetopt"
    doc.install "misc-utilsgetopt-example.bash", "misc-utilsgetopt-example.tcsh"
  end

  test do
    output = shell_output("#{bin}getopt --longoptions foo --options ab:c test -b bar --foo baz")
    assert_equal " -b 'bar' --foo -- 'test' 'baz'\n", output
    # Check that getopt is enhanced
    assert_empty shell_output("#{bin}getopt --test", 4)
  end
end