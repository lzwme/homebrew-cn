class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.8.tar.gz"
  sha256 "666eed833a36e279ba8bdca49773c7a60a52257539d1076aaeba35353e7901b7"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d857a3a20518f2b94cd2aae2233939422cab6f25ed35f979cf0207eeb8ff81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fd30af0005905bc94a3da451de5496e4c7f7c68082c8619f6850677f705786"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c795211b514b087a25052040252d40dd8dbf3ee6ef3087d7e0f35cada48f0e63"
    sha256 cellar: :any_skip_relocation, sonoma:        "a455045b29295d8a358383479dac5505e8ff7acb8ee6fbc1deec7464f15468d7"
    sha256 cellar: :any_skip_relocation, ventura:       "e8aa265787da2679e71b6ca6bbfb82de5441509d3da8063668836f952464cab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfb42ecaad914e2b7c375f803157f241014c9693a6557ab0129cb4eb6720468"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end