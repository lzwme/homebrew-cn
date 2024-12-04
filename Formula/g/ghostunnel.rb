class Ghostunnel < Formula
  desc "Simple SSLTLS proxy with mutual authentication"
  homepage "https:github.comghostunnelghostunnel"
  url "https:github.comghostunnelghostunnelarchiverefstagsv1.8.2.tar.gz"
  sha256 "e44105ca591fa1f2e4af1e6b516ae65833b98a5f8e76093179ecb0fc03c0c47c"
  license "Apache-2.0"
  head "https:github.comghostunnelghostunnel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249c196b62df391cd6f0c5c4697330dba38d32183c1ac7d8c062317f55008652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad4f3707c187d57bc9ad6489402fae0d9db5032026cbcd8f83c4c9f93d6e0c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ea5b9840dc8cc7113d2c6346db486a357e809872209e976a573ed946e18a7cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dec4122fa0bd01ac3ca5da553c852e1206469e737b92ac1c48d4925f316696a"
    sha256 cellar: :any_skip_relocation, ventura:       "8427b971974bf91ed5bd17cb9b3d65f5d1d00edc1d53fd5939a3ed93ea0127f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0afabc0f4ae4a7ef44fa9a90b553e7aa0c0ef72819bf64ebf3bee1e2505673e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin"ghostunnel", shell_parameter_format: "--completion-script-",
                                                           shells:                 [:bash, :zsh])
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