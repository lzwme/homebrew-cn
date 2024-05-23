class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.5.tar.gz"
  sha256 "bebe53f9c4b0adee0415fb679a37409221a84d955ed18411d1c6bae697471cff"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e23a3b83b21ff811e2f645fe7d53fd3e5dd2e733003420c2ac51e27cfc25e0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a228ff9aeaa60529a33d4cd8d1e2706f3dda0757b1df1fa4608d08d165d5c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdda1ecacf567c661aa16b13a4fdf71ed29a13f623f8676bdfdee529e703748"
    sha256 cellar: :any_skip_relocation, sonoma:         "1657cd971ba26df852058a3ef366bf71ac7df9cb11d9f995abdd1089f1a416f7"
    sha256 cellar: :any_skip_relocation, ventura:        "31b0839b0cc447a50ec49aef5ea9c68d34f983518f0ceb721f571b9e8c417362"
    sha256 cellar: :any_skip_relocation, monterey:       "384384e25b7c1961f7736da0a84ee7599c9e236757e6f3dae4617621cd0adf5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51374bfa91da3bae16a78afe8609cf7b06ad216f8bf2fd39e79d90f688149b99"
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