class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "59f5a705f08f539c011e12c01b4e82791130bfb4ccfb332f2b6545945fa70e38"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fca80220d846adf0f6cc3e94de40ce26895a986a8f9efd5ec6225502895b612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fca80220d846adf0f6cc3e94de40ce26895a986a8f9efd5ec6225502895b612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fca80220d846adf0f6cc3e94de40ce26895a986a8f9efd5ec6225502895b612"
    sha256 cellar: :any_skip_relocation, sonoma:        "f518c288ff9fe14daeff9872b233871474eda7709967e1f68973b0bbec7e47e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f518c288ff9fe14daeff9872b233871474eda7709967e1f68973b0bbec7e47e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edc7d2ce04dd68a252d24f79bf50e90217ae1152b977aefca80e45fc77097f5"
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