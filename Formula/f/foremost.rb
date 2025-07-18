class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage "https://foremost.sourceforge.net/"
  url "https://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz"
  sha256 "502054ef212e3d90b292e99c7f7ac91f89f024720cd5a7e7680c3d1901ef5f34"
  license :public_domain
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?foremost[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2fc223a574f2cc52cd6a40d668429f11a7211a34a206f49f1af4329f14a537db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba5d99373d1b35db5088801426f5c2f4d3f091887e0b96f561938008565212db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6392cf002604c650162671aad2867f5247480eb2195472c1d403760430aec07f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82358815462d1b7d346af9c65a6cf8f4982aa7df77d0eda43dc25d1fd5880025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b00ca6770529d4df2682f62deda5cee60cd86553d2402e3e0b4411c63ea444a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5272ace8913590e9e04a3b68f1e0af19ea697e146f0e6ff8f3ffd2cc417661bb"
    sha256 cellar: :any_skip_relocation, ventura:        "2d80ae72544ef8057af1a21228eb3c6772ae35086fc710094c55778c716b0431"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6fc154197c47c601939579ec62059a00dca3c73793ead083e788cf2daa7dbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "46ddc6fa415ef88bb90b4f14698b8051d6167a7e1763863bbdc4116eed590317"
    sha256 cellar: :any_skip_relocation, catalina:       "6be1f3b67ee3002ab30f9f7bc667f55b02d4311a99b4f974af34b6d0353a0139"
    sha256 cellar: :any_skip_relocation, mojave:         "a392a7045508e07e54fd7210de043758e9bf84ff0b0d13867a550a71665c51ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "58e2366417862112c8567bcaa5387c99b8d855bb76228ce6f928fe36224a3cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef5c3ada1ea10d3c0a815cdac8f3bb5489897f81dcbd24fbb2edd49efe1188b"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `search_spec'; main.o:(.bss+0x8): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.gsub!(/^RAW_FLAGS =/, "RAW_FLAGS = #{ENV.cflags}")
    end

    # Startup the command tries to look for the default config file in /usr/local,
    # move it to etc instead
    inreplace "config.c", "/usr/local/etc/", "#{etc}/"

    if OS.mac?
      system "make", "mac"
    else
      system "make"
    end

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end

  test do
    system bin/"foremost", "-V"
  end
end