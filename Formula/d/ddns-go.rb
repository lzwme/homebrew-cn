class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.0.1.tar.gz"
  sha256 "9b8a7e8b2af5ac104c9ae06428cefac2412157ec3896052f0069a91653beb2aa"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59cc8ecea9e230320963046a9477b9aae1cc940c30e03fab387e8d200a902fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8108c391dc9ec5bbf99324762dcf8f794f46c64ac783475e940cf73f5d8c79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857327a3accaa2680cb9f024a24e92e5679c244f859cad2fa42173c2bbe8a417"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7a4318961c010ce6c6646005a0e43fb7b2748fb4855e5fdf6d137b83325b7cc"
    sha256 cellar: :any_skip_relocation, ventura:        "204035fd7033acd15a8b1ae65c5c9e4d78384ae161970e5720d67908fdefe123"
    sha256 cellar: :any_skip_relocation, monterey:       "a697e0d53dadbd45d179c0d2f61f6bc6d2c75f96e6d122838e82c376841b7f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a9c455e76059b670bd0832d271efc44be3a8d943087e9f85af36574b5a773d"
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
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_equal "[]", output
  end
end