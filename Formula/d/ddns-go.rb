class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.8.tar.gz"
  sha256 "1fe5a923fc2ebaf73f46dabf905c307e8149bb33cda5b5d81a962f4cc47bef9c"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f55ba7963469d83438e188a3c71661dd3adb0cceefd73faed7732ce92973704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f55ba7963469d83438e188a3c71661dd3adb0cceefd73faed7732ce92973704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f55ba7963469d83438e188a3c71661dd3adb0cceefd73faed7732ce92973704"
    sha256 cellar: :any_skip_relocation, sonoma:        "35438fc13d60351e8c9ea0a66e6c446fe45898030d4060ff91f52039b8ef1793"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992697af8d506bce43b3f9b9dae855ae6b4180c8b9765e36656c73aef92d134f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382b3ae01b078154d141162053a944258d06cf8a0b34a7fcb69aef5d2c7fa320"
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