class Ghostunnel < Formula
  desc "Simple SSLTLS proxy with mutual authentication"
  homepage "https:github.comghostunnelghostunnel"
  url "https:github.comghostunnelghostunnelarchiverefstagsv1.8.0.tar.gz"
  sha256 "f6f228d305a508b63a94961f68ec0222f3b08b4a84183b9e5893b24ff208929a"
  license "Apache-2.0"
  head "https:github.comghostunnelghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5c4a770c28d9df77399a8ee7c0fff902668947f386ac36895283e503922c5a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c47867502fa6430de13be433c66772445ae1bc2400f7ff014c3f76331d3bc1c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c20e21135d87743cb897c948d7420a9b287c68772d414c547ae575654ca9a70d"
    sha256 cellar: :any_skip_relocation, sonoma:         "878fdeaa11c9f88973f5187600c2bc4a9aa52acbaefec5c9f57a36b9caba46d2"
    sha256 cellar: :any_skip_relocation, ventura:        "c3cc93c50dddcaad5c34f472092d1cc4362e8bb7f5369a9ce4729bfa014b5bc1"
    sha256 cellar: :any_skip_relocation, monterey:       "0317de70abc93397c5aa25a09b394a86eb990e7d286dca5754274f1923decd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a6616d70f3c52053a8e4ff46b6e16f0cb00bc6498f778fd2d78eec0594bc7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o devnull http:localhost:#{port}", 56)
  end
end