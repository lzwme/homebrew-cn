class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.2.tar.gz"
  sha256 "f163e91c65ed0a2a8c2b4594151543b35337fd586782034e5c975dbc49d12ee9"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b98783da7d496e48f63c51da13b7a9a5404f5004ad5ec159c085f0d9a13bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6560db68ef5a78a6cbf85d5ed626b6d4d0b902a0ca1f5bd31e141b73c3713cf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9888a37b25de7765a29823a2bbf2fa3dda8c3a7c00016c4b3f7a5902a23378d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "92768be9bc67de708111f1ef50ffac7218ea27fe990af740bc8d913ccacbeea4"
    sha256 cellar: :any_skip_relocation, ventura:        "6dd4544f2479e0994063ebf4897c3504ae245292c5781c5434b4a87f5bc03b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "f174c8a203b730bb83bbdca75c0d3f12d8093e71dc6e3fd3eab31e89ed76b3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4804e1b800dbcced224b19b46d36acac03d4e9416637a2181516276bee7713"
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