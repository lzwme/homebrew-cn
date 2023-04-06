class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://ghproxy.com/https://github.com/curl/trurl/archive/refs/tags/trurl-0.2.tar.gz"
  sha256 "acef7d251fc13fc97153d5d6949b50744a5bad8aa93840b0d8509cd754ed704f"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9536d617e2810367cb7bfd083c2a8eff6dd41d398ebfdf5504a37ffbdea8152a"
    sha256 cellar: :any,                 arm64_monterey: "df9310558b2c5a196570581bf6880498d478ecacb5773ea0818afb77895863f7"
    sha256 cellar: :any,                 arm64_big_sur:  "00a0b711227a435303ebaeeeab6526f0bbbb3bd939c99e463243cabe20aa6557"
    sha256 cellar: :any_skip_relocation, ventura:        "8b3fa45b478fe57a20d7cc66668c3608768fbc0eacb4b630f26af6fea9a78fe9"
    sha256 cellar: :any,                 monterey:       "27218d3bc35d5d1fc9cfc4780cb5c07d2111097d207a4a8f4b719b504a555c77"
    sha256 cellar: :any,                 big_sur:        "ec8d8143afbc50aa3eaa14b2a8c8e06874b4571017d651a9156e3e638c119847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06536e2899b7dfb6b53d7ffc56cb40fda1b8935ddc99c45266e8e46c41e4245"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "https 443 /hello.html",
      shell_output("#{bin}/trurl https://example.com/hello.html --get '{scheme} {port} {path}'").chomp
  end
end