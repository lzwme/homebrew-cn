class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.6.tar.gz"
  sha256 "5e64b6c9c1723bd955d2d66e637f49d2d76501efc95dd732d7a111cf64da2fde"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "844c1936fd5ec11a9b7fa69aac4fc00ae9082270a6b5b0dd90f6dc5def334f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da783ddd6936fcd7f32beadb524b15c74f34a06147ab9ca6a700ef245fc302d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b48c17b34a56486974309a5113c2ac09146317e87fc300710ce0f8e92a311f"
    sha256 cellar: :any_skip_relocation, sonoma:         "84d9297c844b1180a77c222a0ee2c8be1ad060156a50d78badb7d7fdc147ddda"
    sha256 cellar: :any_skip_relocation, ventura:        "e79a89fecf690c30fc103871d0cd8bbb68da65c5cca387e1221b62bb0a71d829"
    sha256 cellar: :any_skip_relocation, monterey:       "2eea991a4c919c30dab466831d19881952c73f8cded4d6524527972e4c8b798a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "791148e069b440bc085854de6a8c44bf9159a04f2a00ca166374de8b64df8382"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end