class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https:qrcp.sh"
  url "https:github.comclaudiodangelisqrcparchiverefstags0.11.3.tar.gz"
  sha256 "de6a9e29d7c71268e40452abf2f1f593d5d53baa34df5abcb7352ebfd72a952f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfdd2401dc5e9679c88013a07534019ed6f6ed38213edee1dbe434b0db63d03d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfdd2401dc5e9679c88013a07534019ed6f6ed38213edee1dbe434b0db63d03d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfdd2401dc5e9679c88013a07534019ed6f6ed38213edee1dbe434b0db63d03d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a055f36dc6a4351b00893876def921bd413bbdc479f139dd9b2961a96968523"
    sha256 cellar: :any_skip_relocation, ventura:       "8a055f36dc6a4351b00893876def921bd413bbdc479f139dd9b2961a96968523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23530e113b63113b5196d2cecc10df9438edaa37db89d68431bf62c7955c6e99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comclaudiodangelisqrcpversion.version=#{version}
      -X github.comclaudiodangelisqrcpversion.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"qrcp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}qrcp version")

    (testpath"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http:localhost:#{port}sendtesting"

    (testpath"config.json").write <<~JSON
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    JSON

    fork do
      exec bin"qrcp", "-c", testpath"config.json", "--path", "testing", testpath"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal "Hello there, big world\n", shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}")
  end
end