class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://curl.se/trurl/"
  url "https://ghproxy.com/https://github.com/curl/trurl/archive/refs/tags/trurl-0.6.tar.gz"
  sha256 "4564dff7441d33a29aa02fe64bea7ef0809d9fabc1609ac5b50ca5503e81caa6"
  license "curl"
  head "https://github.com/curl/trurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b11dc62609ff8204e8242a765b4fa5f3f45b69b851df51d918fb9d9c6008b9"
    sha256 cellar: :any,                 arm64_monterey: "48b8981e3ae09d23a336d80c6cf37dff058c2e9c216982dae4c45d69bdc02b76"
    sha256 cellar: :any,                 arm64_big_sur:  "10af66b7f65e97c332afc5a69844bc0f97eb0a778c3568e0597fb4cc77a53204"
    sha256 cellar: :any_skip_relocation, ventura:        "14067aacf4e6a1c36f65bcd9de8293ea2706eaf2e91a4b7cee3de0828aab2075"
    sha256 cellar: :any,                 monterey:       "1cbab949671191a8df435a9ded66260f444dea62577e862fddb0b26d7065c2ce"
    sha256 cellar: :any,                 big_sur:        "19a74094819323bc974f1c568113f2172156aac90592895f4796c209e24e5d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "616b7df16644606a8b253dcbc61486567af90305ad1ad00274d335f5edbcaa41"
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