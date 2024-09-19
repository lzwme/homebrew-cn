class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.9.tar.gz"
  sha256 "72ba8f113db5fca91b7d2b1d0916c5f8c65735c52b077f90c1165767cdb17e53"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea04640678f16e4c98a363c84894452753f0944b10f260db681b187acee796d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea04640678f16e4c98a363c84894452753f0944b10f260db681b187acee796d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ea04640678f16e4c98a363c84894452753f0944b10f260db681b187acee796d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bf064ab3a8d4285361054562598f9c2fe9598f3c2418583db9f97a5bdf7c9dc"
    sha256 cellar: :any_skip_relocation, ventura:       "956c3862b9ad594279d220d7be1207e9fc091c799c6726bc92d731c0a229c32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d739f24721cc3677b595be7b4de3b1b96463c0db1240536ce293cc487a9a303d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end