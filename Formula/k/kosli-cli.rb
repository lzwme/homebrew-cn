class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.4.tar.gz"
  sha256 "b6c377047195097e5339dc5981d4c10dbc9a98fb924c85cf66f91d25b20b1179"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1aad2041e33e3f64f37dc0d9f2d30cadcf93d961d0224c547ee22b98a29dfd45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10bc238ccca52971ac0c1e1d07c0d134ff4d944eda50a82f45bbb4ac8e077c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1566005191a57ffbd1296b806a2a7ea4f731ee1ff009de14ffd5e8def8beeb8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "026785a17cb010e220bc158ae3b87a49d88fc43efdaefe021ae29d2031489720"
    sha256 cellar: :any_skip_relocation, ventura:        "a8ad790203a06778bf8669c5e1b12ca917b509a666b44ed8b6f631af8583c1a4"
    sha256 cellar: :any_skip_relocation, monterey:       "49cb7db43999c61b2b376c88824ac00fec72825011e8b38e7797ab58421a3098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1021412db3c730709771488e5bb9215e059c9e893763af8d6663eb9354d50ec"
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