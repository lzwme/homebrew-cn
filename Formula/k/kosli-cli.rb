class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.11.tar.gz"
  sha256 "783d5d240dddfb322b5910ad3fb41b8ba201a97d4f7e0240993909faedd722a2"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ffe4c875641148543335b1dee750f30664848d7bcd827455b9bbb5230103db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3158c22e772c94c7914295e2faacfd3750832a64f1bd77273f7c1b1e09280db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68704fe88402d65b90dd1348ccb114c283a97544bc77a24c182a2838d58e2857"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1399abad4bc1921b25928373412322af0440a2246f1fffdde46574bc4eecfcd"
    sha256 cellar: :any_skip_relocation, ventura:        "d3512e3ba08498c2061709e744911968d97544e797471ac31bac4c9fce65649a"
    sha256 cellar: :any_skip_relocation, monterey:       "029bc20d339e0c6fd5d72220da8c55ebd34613e1212af9a3d0a228c06bade0d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57d7f60b4fe8cb3b725b6b0adfd9ba0d66f6786b32b8c72e489ec99d9d5af5a7"
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