class Trurl < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https:curl.setrurl"
  url "https:github.comcurltrurlreleasesdownloadtrurl-0.15trurl-0.15.tar.gz"
  sha256 "e58d9a698c009b2b1381f5636b5334ce7704ad2cd5ae8d30da97d483518a7f25"
  license "curl"
  head "https:github.comcurltrurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b3827a4d44bc0021723de929450bd35af9513126aac0c4ecf92960fc1ad8cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4bc38d1d291c68340106a048aaa3ec79a43709f167d2a55d7705d7071a952e"
    sha256 cellar: :any,                 arm64_monterey: "f2e84b971dc4acc0efb3d106bf4cb61442d9440373341d1aa2cbfa00eb56abcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1417e4455377b012e44588b5d45377a3591fbf26d2960b01f0f72a7c0e7d69d6"
    sha256 cellar: :any_skip_relocation, ventura:        "4e3990113944427367a33f6c628999195c70a4754e9c92e8475b7b7853312205"
    sha256 cellar: :any,                 monterey:       "b4aa49f3b0a0b8eba1d4a742f5c41cc813604969f0bcc7d8afb659735377dba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25679b3441558a6b23d76c8ae18308dc8f67c5ed8c0a490cddd90be20507e38f"
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