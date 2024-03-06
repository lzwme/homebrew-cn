class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.6.tar.gz"
  sha256 "cc310b3cdf1cdcb3cc29e0e52e5580bcc438a5e238b1862a746b8bb3f2aadd66"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c22b6ff41f56fe4bd5b4cfb5a683ae65cb9648b89e5b7193c361e0c2417765f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a1f06c2a06383a06d465c6b50e81014efb427ed9a6b6271dbd40cd3c29a1db9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d663954a65f918dcd699ec79c74b3486772411c1706d5e6bd95623ec8997ae16"
    sha256 cellar: :any_skip_relocation, sonoma:         "15981e67db83d996788e80af533ac95cc7ce878bebb2f91a8f4a1fc6eb3f1e66"
    sha256 cellar: :any_skip_relocation, ventura:        "e0755c8cc7993dd2616b191dbce4df19700791cc88b62f682804d86e5380dd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b61a3cd5f099b3df6ac9693659fa828e29f14a78053c879dfe0a4f9dc5309862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0772aa69a1e17bc8a34ae3e467dc59237ed032f83ffb51c7c3c02946cc9bb710"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end