class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.13.tar.gz"
  sha256 "304190d35335b1cbf22937fd1bddc7f683d70fccce571cce73034ce80b357bf1"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d933c6d1f98eb1ecb40aba137f906245406fdc785baf258ab275116646822d28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d933c6d1f98eb1ecb40aba137f906245406fdc785baf258ab275116646822d28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d933c6d1f98eb1ecb40aba137f906245406fdc785baf258ab275116646822d28"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec211a3f905c6f800be60fbc7870b3a42ab7256ed72e0ac0cf49c64c0a2deaac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6c539298e9dc9c7adb83e3e69e689cfa5868b0e2aca4e03e6f6f37a2c718bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa238a2a21bac61998b6a6436d0d5681730bf25fb2e3ce4cebf596968a4e2b97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end