class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https:kargo.io"
  url "https:github.comakuitykargoarchiverefstagsv1.6.0.tar.gz"
  sha256 "7b65bf32c0873a8a4c8620d2ed314673900be5c886644ddf3638695851d3f512"
  license "Apache-2.0"
  head "https:github.comakuitykargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613fbc74fd5d6d8168ccabafbd45256b4441dd5cb8cadf6a23e79b9f241f4aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8fde3235dc45f5821fe6ebec727191952f5fe2b6f34a9328d3ebbaf6d22dad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3368be40d463c00bdc338d998686f27313562e0fb2ab9b86555aa620a0b7670"
    sha256 cellar: :any_skip_relocation, sonoma:        "813e5f6635774fbb8d837d5ecfc70b3900ea352e818b86e6307fca18c9490125"
    sha256 cellar: :any_skip_relocation, ventura:       "2b82cf4581bdf0fa06a6a10005cb3c87e805a985732e00f44d79e196d11ddcab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633bba520a2b7973f00a353853df287ae7d7310197d329d34b4a468c5302e845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840b5e94f5738dff6d9d354d59e54eaccd2796e65adad0cc892d2161c05a41d5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.comakuitykargopkgxversion.version=#{version}
      -X github.comakuitykargopkgxversion.buildDate=#{time.iso8601}
      -X github.comakuitykargopkgxversion.gitCommit=#{tap.user}
      -X github.comakuitykargopkgxversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}kargo config view")
  end
end