class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https:github.comayoisaiahf2"
  url "https:github.comayoisaiahf2archiverefstagsv2.0.0.tar.gz"
  sha256 "caf671bfdc24af09045a5f682a42d275f728408fde44af8e37ec34a8d88222df"
  license "MIT"
  head "https:github.comayoisaiahf2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb1609ef3e52b072d3294aef38d927424e6c534789661ebfce4162f012121e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb1609ef3e52b072d3294aef38d927424e6c534789661ebfce4162f012121e89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb1609ef3e52b072d3294aef38d927424e6c534789661ebfce4162f012121e89"
    sha256 cellar: :any_skip_relocation, sonoma:        "f72c41655b4bdb9df3e1ee74ca7404b0b11e82a9d1557bf7492cf3f800088083"
    sha256 cellar: :any_skip_relocation, ventura:       "f72c41655b4bdb9df3e1ee74ca7404b0b11e82a9d1557bf7492cf3f800088083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82a4234da20b24657ce3e44861d715029f62c7e04423739bfb5f88ff8d48ec6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, ".cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath"test1-foo.bar", :exist?
    assert_predicate testpath"test2-foo.bar", :exist?
    refute_predicate testpath"test1-foo.foo", :exist?
    refute_predicate testpath"test2-foo.foo", :exist?
  end
end