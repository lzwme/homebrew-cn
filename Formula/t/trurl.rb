class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https:curl.setrurl"
  url "https:github.comcurltrurlreleasesdownloadtrurl-0.15.1trurl-0.15.1.tar.gz"
  sha256 "680342d123b71a08e77275f6dd4ac40847cbd3289c6ec967d4c976ea28626f04"
  license "curl"
  head "https:github.comcurltrurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "211e61bf316d115660df215948fdb77ec0d33ab7b677e300fb397e1c4e3f632c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4f5ce0bc52bc43d3f614a63d27c6ff3575dd24acf049d4acacd9e294e277cfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "085055517e0d7b833586b36d5d8f597930ab2d0ed8126b74514ffa5b23bf874f"
    sha256 cellar: :any,                 arm64_monterey: "e74019c9ec190740a2942f7eec30cead616f7e8e2b7a1afff39bc1e15d197876"
    sha256 cellar: :any_skip_relocation, sonoma:         "71a5b6568deace0bca74de4712693673c384adb1fe3f5e0d3a772df7327226ee"
    sha256 cellar: :any_skip_relocation, ventura:        "4cdf4706a1adbbd720d14a2508f31844e0000267c7e1a26c85e247b4b4d3c240"
    sha256 cellar: :any,                 monterey:       "a3e5a15b89b94d211892a53eef5e94ca78f2b8bb8fe366df3b9bb3bb4b8725ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05e8554af4ae6e60bbc2136a26b37ba97c6d0517ef2e3a14c927cd4f2e4f8ac1"
  end

  uses_from_macos "curl", since: :ventura # uses CURLUE_NO_ZONEID, available since curl 7.81.0

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}trurl https:example.comhello.html " \
                          "--default-port --get '{scheme} {port} {path}'").chomp
    assert_equal "https 443 hello.html", output
  end
end