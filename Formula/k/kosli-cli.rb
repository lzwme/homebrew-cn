class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.15.tar.gz"
  sha256 "a03dd42c6bd5ce0ab73e7c1431e3c2f1253119a7dfba4d0118acb055eb951c63"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28dc88b9d65bd8217a502315a0c0c392a2d14f8d731627bc8ee1c26cdd8351d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28dc88b9d65bd8217a502315a0c0c392a2d14f8d731627bc8ee1c26cdd8351d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28dc88b9d65bd8217a502315a0c0c392a2d14f8d731627bc8ee1c26cdd8351d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c2cf8e21e497fdfd2feb5b6dbeee7001af54365cb5d82aa443534e830f7e17e"
    sha256 cellar: :any_skip_relocation, ventura:        "7c2cf8e21e497fdfd2feb5b6dbeee7001af54365cb5d82aa443534e830f7e17e"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2cf8e21e497fdfd2feb5b6dbeee7001af54365cb5d82aa443534e830f7e17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70cac079fe6b46b6df7e965fb0ffa180f56a5dae162538e201e4e498a2d5b1db"
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