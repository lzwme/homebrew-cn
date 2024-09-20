class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.16.tar.gz"
  sha256 "8a12c70cc024c62560a651a7ea8b98aa4df2cb07cfa77af6823aacddfb4d5b2e"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b5076012064b2141d6ba73514875f3aeb44abf7125366c4a1e6df49f627cbb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b5076012064b2141d6ba73514875f3aeb44abf7125366c4a1e6df49f627cbb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b5076012064b2141d6ba73514875f3aeb44abf7125366c4a1e6df49f627cbb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "182396ffd2cf820dbbfa6d596e321308b4ca2b0e753e3b37f5cb7b5dad9e1ece"
    sha256 cellar: :any_skip_relocation, ventura:       "182396ffd2cf820dbbfa6d596e321308b4ca2b0e753e3b37f5cb7b5dad9e1ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb5b34e786d7a22e74f147fa293cbf16b7ea91620f2cf9b87b0c16d61974d44"
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

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end