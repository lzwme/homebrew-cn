class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https:ubuntu.comlxd"
  url "https:github.comcanonicallxdreleasesdownloadlxd-6.2lxd-6.2.tar.gz"
  sha256 "44f98776b9e9e1d720da89b520d75bf8b7c3467507b2d24ada207a160ec961f3"
  license "AGPL-3.0-only"
  head "https:github.comcanonicallxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "557ad99b5bcc304ebe9fa87cfecc9df2e5df9f260f98add9ad9904831c2109f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "557ad99b5bcc304ebe9fa87cfecc9df2e5df9f260f98add9ad9904831c2109f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "557ad99b5bcc304ebe9fa87cfecc9df2e5df9f260f98add9ad9904831c2109f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "38d351b3937d975859d7298d54b14fb06a8293fd999674d45f07c04f6223cd7a"
    sha256 cellar: :any_skip_relocation, ventura:       "38d351b3937d975859d7298d54b14fb06a8293fd999674d45f07c04f6223cd7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "debfd85a1ae466f804ddcccf425d317d4bbfce55db8e42ea7ba3d87a32f9b460"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}lxc remote list --format json"))
    assert_equal "https:cloud-images.ubuntu.comreleases", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}lxc --version")
  end
end