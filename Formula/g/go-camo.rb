class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https:github.comcactusgo-camo"
  url "https:github.comcactusgo-camoarchiverefstagsv2.4.12.tar.gz"
  sha256 "985af95cb0a0cc50aba6e96a973c6c8734cd15287f504f3be47fb87e632f204a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7b0ef3504d7609bfd10f02e2b76c5221d93565f2c88d8536555ecbab8d90512"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b0ef3504d7609bfd10f02e2b76c5221d93565f2c88d8536555ecbab8d90512"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b0ef3504d7609bfd10f02e2b76c5221d93565f2c88d8536555ecbab8d90512"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f58f463325507380e191575537889a4cc38936c8624cdc121c2ade5a6d3ccb9"
    sha256 cellar: :any_skip_relocation, ventura:        "6f58f463325507380e191575537889a4cc38936c8624cdc121c2ade5a6d3ccb9"
    sha256 cellar: :any_skip_relocation, monterey:       "6f58f463325507380e191575537889a4cc38936c8624cdc121c2ade5a6d3ccb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059955250261faab2b74c8cb0656ae607666357a8613a542854b5c538f550003"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["buildbin*"]
  end

  test do
    port = free_port
    fork do
      exec bin"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http:localhost:#{port}metrics")

    url = "http:golang.orgdocgopherfrontpage.png"
    encoded = shell_output("#{bin}url-tool -k 'test' encode -p 'https:img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end