class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.85.1.tar.gz"
  sha256 "257847ce13e05022dabd942a70829b45aef7f1ebc19f662dc471e9049c847a42"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44cf7f31fd5924650b3d8e0c5aa895bf0a81912aa92eb28de28958ef3218319e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5569a983006e9fd05ebb8da586782f776b14a235d40c768db7a41a2ff8203014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96b9ea10cd95a1f2a18f8801b2ddb15fe82de2d87c6e006e7cc686a9249e2d88"
    sha256 cellar: :any_skip_relocation, sonoma:         "26956bb91a8854e969803945026c65e4dfd4ae3dc3bbc99089d6480cb044957f"
    sha256 cellar: :any_skip_relocation, ventura:        "af0b24d17666add08ff00c42195fbbab38f13f7f770940a3529d9f88f94ac156"
    sha256 cellar: :any_skip_relocation, monterey:       "28e6a85b0482b9c0bf116a5e65aad87655e50c39fb47071afbc21e5914e939d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689fd7b11a601963cb805d91017698daed2a6e9bb32c5ad2857ccfec09cf48e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end