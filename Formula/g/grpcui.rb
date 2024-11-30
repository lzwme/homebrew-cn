class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https:github.comfullstorydevgrpcui"
  url "https:github.comfullstorydevgrpcuiarchiverefstagsv1.4.2.tar.gz"
  sha256 "8548a3ccde0b886ae14ea78fae3e58d28922079e78a08d29e6ef7b9230190375"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b2c98ff5ebbb2714237618e9d6b4675170b5fdf9027031c7bbf9bf7955b1ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b2c98ff5ebbb2714237618e9d6b4675170b5fdf9027031c7bbf9bf7955b1ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56b2c98ff5ebbb2714237618e9d6b4675170b5fdf9027031c7bbf9bf7955b1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87d24cef81c9d5205723a8b7a60b27b15b185886b07b2ef4c7b4d8d3271ef33"
    sha256 cellar: :any_skip_relocation, ventura:       "b87d24cef81c9d5205723a8b7a60b27b15b185886b07b2ef4c7b4d8d3271ef33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e64ce95608640514130cde5f1040864d168f08344410932e066b8d1c377cd958"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), ".cmdgrpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}grpcui #{host}:999 2>&1", 1)
    assert_match(Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host, output)
  end
end