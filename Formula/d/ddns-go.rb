class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.8.tar.gz"
  sha256 "800271b838f62fa0b59a1e05ae8aaced5c92de8872c1c59c73840aebf73b8f8a"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f59b3d0f506436e6935721996917785bc7a0757133d4fdd30c7b58b13318727a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff013b19952be75ee0bcaa22f34c85584fff5bc0f860780aa30a5372b9b4dc82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579afe19274c49472450dd7b9d16b5c26b746b156f3999bcc2382669a369ab87"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4a9333eaf6394049f3713109d89317ae8c243624f7bea928a1413574fb14000"
    sha256 cellar: :any_skip_relocation, ventura:        "e144c7dd2f2aa9f1ce2f73c6e977482b09d66887fd8f97a3831cdf3e034d6275"
    sha256 cellar: :any_skip_relocation, monterey:       "024b59ef63836fd5581a0812bcb3c2318e5baa9718ca94e890b37cabaacd2601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19e399f4d52ea94e5d54beed9bc7eb60a3ca2a72a87919da4c2274b509d2c35"
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
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_match "Temporary Redirect", output
  end
end