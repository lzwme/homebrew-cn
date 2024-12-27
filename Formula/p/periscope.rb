class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https:github.comanishathalyeperiscope"
  url "https:github.comanishathalyeperiscope.git",
      tag:      "v0.3.6",
      revision: "78730d745e0c5ca6dcbb67d9a20ccf4690be4fba"
  license "GPL-3.0-only"
  head "https:github.comanishathalyeperiscope.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9a9431954d9f582d2a8f99cec9ca9040a8e5667a142c30951f2e5af7552ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3a70ffec7865f99e349cf0f46b07e5dc477edc9654e338eaa1d496baa1cdde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea6c1e8927e40c7e82497b75848141956e4d690767f725c5678355e97a7337a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd975a00c2ad2fbcb01f51f45a98a3bb2f319f2d6ec59f727f7595befa04115"
    sha256 cellar: :any_skip_relocation, ventura:       "2de7db638f37e8e37b809f2de5da5c06a982ad7b104a9b6b7ddca81736c395c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8fbffef927a74b8bb78f65f72b9af88def122ce884f4c2aae939148092abc6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin"psc", ldflags:), ".cmdpsc"

    generate_completions_from_executable(bin"psc", "completion", base_name: "psc")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}psc version")

    # setup
    scandir = testpath"scandir"
    scandir.mkdir
    (scandir"a").write("dupe")
    (scandir"b").write("dupe")
    (scandir"c").write("unique")

    # scan + summary is correct
    shell_output "#{bin}psc scan #{scandir} 2>devnull"
    summary = shell_output("#{bin}psc summary").strip.split("\n").map { |l| l.strip.split }
    assert_equal [["tracked", "3"], ["unique", "2"], ["duplicate", "1"], ["overhead", "4", "B"]], summary

    # rm allows deleting dupes but not uniques
    shell_output "#{bin}psc rm #{scandir"a"}"
    refute_predicate (scandir"a"), :exist?
    # now b is unique
    shell_output "#{bin}psc rm #{scandir"b"} 2>devnull", 1
    assert_predicate (scandir"b"), :exist?
    shell_output "#{bin}psc rm #{scandir"c"} 2>devnull", 1
    assert_predicate (scandir"c"), :exist?

    # cleanup
    shell_output("#{bin}psc finish")
  end
end