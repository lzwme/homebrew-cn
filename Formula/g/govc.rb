class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://ghfast.top/https://github.com/vmware/govmomi/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "da5ed306f41a0ee2e8bf56f85e39092863ea34a008d80fdf63d43062c75ec161"
  license "Apache-2.0"
  head "https://github.com/vmware/govmomi.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fae7c9680733c54b9e427e7e8d42e8c4e17502f0c1f4789fa6d4d141a9de54cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fae7c9680733c54b9e427e7e8d42e8c4e17502f0c1f4789fa6d4d141a9de54cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fae7c9680733c54b9e427e7e8d42e8c4e17502f0c1f4789fa6d4d141a9de54cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "234c9dfc775995e5bab929230de19ef81d7ad6e9d0eb0748ec94c576ac614091"
    sha256 cellar: :any,                 x86_64_linux:      "6db9fe8480798624edccfc796e00f2303a083b6fd8c622326139d56ec9b1afe3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "govc"
  end

  def install
    ldflags = %W[
      -X github.com/vmware/govmomi/cli/flags.BuildVersion=#{version}
      -X github.com/vmware/govmomi/cli/flags.BuildCommit=#{tap.user}
      -X github.com/vmware/govmomi/cli/flags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}/govc env -u=foo")
  end
end