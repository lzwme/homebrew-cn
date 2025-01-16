class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https:serfdom.io"
  url "https:github.comhashicorpserf.git",
      tag:      "v0.10.2",
      revision: "93c69c072b854e28812e80a803ca769ed1f85999"
  license "MPL-2.0"
  head "https:github.comhashicorpserf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8482eb78b564538637113568e1a01ef5cf6e5f73f6bf2de2091ac90da0d4b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477865641aec656185e1f20a7bd4531578997adf097026094474f7f31dd9d734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a136bad43bff7ec7b5a00f3c7ffb28e8ca103be5f107ab6a6e6c6c8e17766aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe76c50cf2b73553658e7af342ab06e97d755d0c83883568ac1a3005d5ec949"
    sha256 cellar: :any_skip_relocation, ventura:       "91043f744faf180325691d7ecf97ece4525a6578e35f61a8c15ea11b58953732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31db74461f5197f712b31fe8ce24137c8594d691244ed0b1a63702f9e75caae"
  end

  # use "go" again after https:github.comhashicorpserfissues736 is fixed and released
  depends_on "go@1.22" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhashicorpserfversion.Version=#{version}
      -X github.comhashicorpserfversion.VersionPrerelease=
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdserf"
  end

  test do
    pid = fork do
      exec bin"serf", "agent"
    end
    sleep 1
    assert_match(:7946.*alive$, shell_output("#{bin}serf members"))
  ensure
    system bin"serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end