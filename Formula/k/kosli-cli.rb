class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.17.tar.gz"
  sha256 "aa9b0057da08dbd32fd30c8a49c9b1f4335097e87154f8a2f05c16f40eb57c17"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d3cca39bde7899aebe4a54823b806613bd10171d25664747f147e89a46bc9f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3cca39bde7899aebe4a54823b806613bd10171d25664747f147e89a46bc9f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d3cca39bde7899aebe4a54823b806613bd10171d25664747f147e89a46bc9f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ce05bb742887dad7c9e0fcc0ae1b0dc791fdc9762da770f801407bce9fa9ca"
    sha256 cellar: :any_skip_relocation, ventura:       "b2ce05bb742887dad7c9e0fcc0ae1b0dc791fdc9762da770f801407bce9fa9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10aabb438b3bf9b7dc5a047d1b24f4afae617acb76635e7a7d831ba8ccaf7272"
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