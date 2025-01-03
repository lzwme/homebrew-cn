class Ghostunnel < Formula
  desc "Simple SSLTLS proxy with mutual authentication"
  homepage "https:github.comghostunnelghostunnel"
  url "https:github.comghostunnelghostunnelarchiverefstagsv1.8.3.tar.gz"
  sha256 "999cdc019ad1ec90b69370169469d4a32bf7bfffe646c7843aba083e2e35e613"
  license "Apache-2.0"
  head "https:github.comghostunnelghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a609d6b1db75c4a0910e3a5a2e8b284530846c06d9a58f8509dd04d18ef1fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6021c0bc7b644d11395e44b0a5cb8f6afe54d2deb2478724a60b8ab3f5c37995"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65bdcb89f9390e37993a9b57655101280b186bf6b96830ea5c8d9770465a51bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3419797e2d0f9178538f9c6a196f6a6966251c3e30825b4258e42f6c179c510"
    sha256 cellar: :any_skip_relocation, ventura:       "ea692e2c669cfad03bbcd9bcfcfd84fcce56e0f503f68f60b1bb12af1c71f713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618110170381d6a89b23b2681cc4ea3f5569399dd4be5aacfe7acb69ec7a3ee4"
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