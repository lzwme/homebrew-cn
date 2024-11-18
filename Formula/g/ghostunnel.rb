class Ghostunnel < Formula
  desc "Simple SSLTLS proxy with mutual authentication"
  homepage "https:github.comghostunnelghostunnel"
  url "https:github.comghostunnelghostunnelarchiverefstagsv1.8.2.tar.gz"
  sha256 "e44105ca591fa1f2e4af1e6b516ae65833b98a5f8e76093179ecb0fc03c0c47c"
  license "Apache-2.0"
  head "https:github.comghostunnelghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89135bb036c1063dbf0293d75366d92104b66492db932daeee6bf8af01df7221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6e62203948bc3fe40061ac7460def7fe7bd1d04f652da49ec997727c549cf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdf0cdbf10be5e5e0f096a71298d024de086ef092b07bcc999c5745872012c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "670dbb5113ac27a58604a427ce1b7f5b227b7c3175489acb5a446a0d0d722820"
    sha256 cellar: :any_skip_relocation, ventura:       "461e65e35836026629f68f213b6ecc25ef60a37321feb48be8c950ac542f8e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a74d14387e5643d7ce02bd297dccf56a6c61c9056bd2508c9e5343e66432f9"
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