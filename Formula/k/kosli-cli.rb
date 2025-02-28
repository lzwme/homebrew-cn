class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.10.tar.gz"
  sha256 "0df4d68ebdb369a7769e5eeab8e787552f578a568de008efe681bf0b1fa2dc5f"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b0c0ba942fafbd94a283e9863c48881b88e13d99a1db4c0494080cfc9ab79e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a737ae9b49e5466443cf8167b072701a156cd8aff7e4164d327bece2679b4b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe0d0933f0a307cebc6a97950cab30a792e98e88ec920a2567e721620feb7189"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3374917b56279236c1442887e1b13b13d1765dc276a208faed09c4d5ede2edc"
    sha256 cellar: :any_skip_relocation, ventura:       "adcea5fbc15f2c7f4bc95f3583ff06227a1106bd82e3f135d50c877ccca31f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31167acddeb965e03313c7871944763f8f3e9278d5e254699a42e11344945713"
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