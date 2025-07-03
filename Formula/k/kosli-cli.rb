class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.16.tar.gz"
  sha256 "e5d1fffc37feb9243c6d29fa2e9c9d910522c0d546d52204773cb27ee5d5115c"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bbe6dba9c975c84db62de63675e51a6914faef0aa0f95dacbfc69e843d6ff6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d95a10e09bdfaa8071bf4d5c20b1b51e6a6aa24db68b39b5a9405ed433073b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17c4acacfd4a1c961b0d1561e2968b2050af0546f78b03f7b54d3ec7d19b7f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d660e4f5f6a9b370fc558a222974c3dc3dffd9507aacd7497097c4c52a4d1e55"
    sha256 cellar: :any_skip_relocation, ventura:       "b8ca0766e25dd6b323491c923afdb98a3478a46443d0ea7b9abb40b721dd7c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0820ee4deae5d66e3fdc1670612c8f326b90b00dbc746f521b329ac4f6344a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf9212deed52ffa26da3f60c06de9de4f959e1cd5aab1bbb9b94a8d34c61b1f"
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