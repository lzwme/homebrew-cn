class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv9.6.12.tar.gz"
  sha256 "d5e55d587021466d57d7d0fe4f9f2a5f9548063bf25b5af8ce275389951e059b"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb0851f98a042a596adccd171a392b33eb78c355eb63ff96fde4fc5ecc6a325c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8df372eaa2e92c730c8f13324fe57cf274313e493ce7db5e60e8eb881388903"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9a3b5aa4d5716931fb4d7738bb682493c30082f334afc33e0543a51481d5e2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7deb235765ce6cc55296d3ce721871319692652a1c6959de14b771484c86073"
    sha256 cellar: :any_skip_relocation, ventura:        "83d9221b8d40253141afb7d64e95f9da9bb614b7e20ae63eeeb2e45e340bc17e"
    sha256 cellar: :any_skip_relocation, monterey:       "37df03f267cda08dd938d0ff05f9da58c345eec1eaf8893203fbf93b848ea071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0da9af4a816d9149d2809651a3c99a39dc5c04e9e1d914a86aec1fb48f48395"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end