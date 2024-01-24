class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.7.6.tar.gz"
  sha256 "39a8dd6e475155a2972d254d3ed747bee0af99924d893238ff645a79be29774a"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68ae573a6991dc020b4df5618123484ec862cd3e35d41123bdb73e7d1239f9f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef3f704344039682149747faad739c4fff9b3ab1b7ad64c42272a5e76ac44949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e360a52c931e32b4bfe36682e0e628e165565b3b61d37628539651e108ea18f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b537729ffee8aa42746c4d108a5ee9803df48d67a04e2564a84fa6f88642d837"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf30f10d63740701f07108b78d2feb241b88dd12ca2ff05382aa5e522f94080"
    sha256 cellar: :any_skip_relocation, monterey:       "36a2fdb9cb12ef099269bf19833bb80691a2777560a4800e9d1cefbb7de5e317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff33c84d004c995866292351570cec9a0900adfb8c7641c11704973e276a5b3"
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