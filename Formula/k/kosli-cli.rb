class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.5.tar.gz"
  sha256 "8c6883f833e1b8c39a087ee37fbbfc6f61eeace069f9124e1bcc1bfd6fb2b8e0"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "235548f2f78b9eac0e2e727e1912565c38634f76b602092db9d498fc2a933cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3702accddf7b3d1e588dd14e847876df5c9ce092773720560573321f20e920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58567195888f66d010d7660ef8eafe9c3543b2730dff78c96bf80a5678985194"
    sha256 cellar: :any_skip_relocation, sonoma:         "637c50663fcfb99be6c469ead0d7d9c00da35cd74cb272d076e1cd24eecd2bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "08267cdde8e2e74fe6c275c21a2feb5e33065a11cf446d66ddcda7f03bfc619a"
    sha256 cellar: :any_skip_relocation, monterey:       "ac3381c669fe5726138f071137c4f8390f96e9b285b57272e48bb61b97db0b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3337632c8c40be39e6b20137d05edf5ef487193a60bcb9e902a48dbe6dcc3c"
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