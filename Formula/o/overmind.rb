class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https:github.comDarthSimovermind"
  url "https:github.comDarthSimovermindarchiverefstagsv2.5.0.tar.gz"
  sha256 "5f4c217b67a62433a738991b29bc7dee31e748ab7e9eb03a5505b49afa27ec5b"
  license "MIT"
  head "https:github.comDarthSimovermind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70f2114d4d3ad2b4f7e131e8e28876d4abe94faa1bf7b27fd94e9f717d2373c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4512e978d6c4664cb8aaae7470cb665072c20b4c6589dfad1c018b6da5b39ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62750fbd9b429d90baf16a43d16d470ffafa2fcbe50cce25c2dccbfd6c5b320"
    sha256 cellar: :any_skip_relocation, sonoma:         "62793053255bcb627e97739e5b9e4ea7deba7b94d770e0eac06cc03636a5c304"
    sha256 cellar: :any_skip_relocation, ventura:        "b172a7b77b2fa5d608b4d13dc902c5d43726d726656c84c8030ad426996ae025"
    sha256 cellar: :any_skip_relocation, monterey:       "c2adae63e8d18753674bab5fafbf9755d52f9b524b5a23cb1b85380415bd30bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4444baf6d40a3896025dbaccb345585c0b369e833c3a72c2195a597781f6b50a"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open .Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}overmind start 2>&1", 1)
    (testpath"Procfile").write("test: echo 'test message'; sleep 1")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}overmind start")
  end
end