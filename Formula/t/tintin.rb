class Tintin < Formula
  desc "MUD client"
  homepage "https:tintin.mudhalla.net"
  url "https:github.comscandumtintinreleasesdownload2.02.40tintin-2.02.40.tar.gz"
  sha256 "62107b870af40074c9b46cd6f7a5b0bab5de5799d741686f0cab896bd30b99b9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8042087ffe92ca50f3b82204625a901d5962e86ba5d056ea8ea80f85815ec473"
    sha256 cellar: :any,                 arm64_ventura:  "791f15c61605249caf7853c21eee988c2356692d2f199987a6de600357960b78"
    sha256 cellar: :any,                 arm64_monterey: "9de278cf85687b591cf969a070193efba115e45f47ee13ba48f7e6f5675f3063"
    sha256 cellar: :any,                 sonoma:         "d668d59b2ed1128957d1081fe6a346f8e173471821f7d486741dd9806129f8a3"
    sha256 cellar: :any,                 ventura:        "966e84a4569ec47326b53eea8fc5a5371bd1a4157e3eb87ac70136e39cbbc632"
    sha256 cellar: :any,                 monterey:       "45507c5ba6f7790248278d2735fae503db8eb399ddb1860a5f9477ff0e72ea60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7734af32a6e92a5def85d2c18ca3655998b33e9720a19a5a8e437d42bb311c96"
  end

  depends_on "gnutls"
  depends_on "pcre" # PCRE2 issue: https:github.comscandumtintinissues163

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}lib"

    cd "src" do
      system ".configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tt++ -V", 1)
  end
end