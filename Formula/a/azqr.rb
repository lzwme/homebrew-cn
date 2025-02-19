class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https:azure.github.ioazqr"
  url "https:github.comAzureazqr.git",
      tag:      "v.2.3.1",
      revision: "d51d95589a1b944e196f4a144be1972af9382c61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca73999116b8640104882d88bc9f8d8cd9a26494a566533eff7fff6c7485bdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca73999116b8640104882d88bc9f8d8cd9a26494a566533eff7fff6c7485bdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ca73999116b8640104882d88bc9f8d8cd9a26494a566533eff7fff6c7485bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "680e6f7881e66390111c08f07d3bdcfcacd1a33ddea610bcbb829a44697aa54a"
    sha256 cellar: :any_skip_relocation, ventura:       "680e6f7881e66390111c08f07d3bdcfcacd1a33ddea610bcbb829a44697aa54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df6ddbc27e4a74b4207060426f9700c1bb90bb923defcf3676d1cdcff2128c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comAzureazqrcmdazqr.version=#{version}"), ".cmd"

    generate_completions_from_executable(bin"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azqr -v")
    output = shell_output("#{bin}azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end