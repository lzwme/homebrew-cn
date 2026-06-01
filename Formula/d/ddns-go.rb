class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.17.1.tar.gz"
  sha256 "05ae7ef07241113ee2cd861be530524f06856fc7368b84846db5137a477277ea"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e42dc8793aa10777e908f0d481a5ba4426da407172d51845d5375d73a52512"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e42dc8793aa10777e908f0d481a5ba4426da407172d51845d5375d73a52512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e42dc8793aa10777e908f0d481a5ba4426da407172d51845d5375d73a52512"
    sha256 cellar: :any_skip_relocation, sonoma:        "392f8071e5c478d0f24599fedf792c0745bdf256699a956ed997426a43e74b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13179f82710931bd8ec44f9038227637a42b760ee688e1313f93e47f5d35791"
    sha256 cellar: :any,                 x86_64_linux:  "1bbceaf49fe005e3470d9777941c91924d96ce8bfe8a7fa7e05cc3d13e07c856"
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