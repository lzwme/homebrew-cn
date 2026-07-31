class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.4.tar.gz"
  sha256 "80f3816d95933949ce7306b988b2612d91b95c6992af8e956378628fde19b615"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db99bde2065722d0253ca013467d21948686ffcedbe852a6aa6746c747b722ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db99bde2065722d0253ca013467d21948686ffcedbe852a6aa6746c747b722ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db99bde2065722d0253ca013467d21948686ffcedbe852a6aa6746c747b722ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe4cec10cd4a183f1c16d35a7170ef370bf0cf2400f105f756de1b74f372a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced377e28871bc7abc7654320d871dae9965cb7f07322279e7d4684ce89fb5e1"
    sha256 cellar: :any,                 x86_64_linux:  "746d870305e90448c00c56cefbd6492cc4af007c211e5dbe3d9a185ccd8733b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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