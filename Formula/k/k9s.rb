class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.30.0",
      revision: "dcec53e061ec3372a62e945b8afa44640fbbebb5"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b70a0e7576df51d0aa7095d28d8e005c26c0b3b2aae64bb0bfe0e49d2f5c0049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "224ed682a0962c8ab7118c541c9906960706edf94c62a3fd09624a4ab7f4f09f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0ba222c57897794fc4c40e3ad4d77d9facd8761efded83910747fc424876ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c80797ee286fb0080d27a8ab8b5f017a65ac868fc6e5ee73776a2bed4c1d5b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "118bf0d023dc72279809b53fee1d985395d711c5cfb5ad3281fcff7eb03897a8"
    sha256 cellar: :any_skip_relocation, monterey:       "3d80febe5e0c44a9762b6a4b648ac2ae34fda19069e2493c43c0c79da346cc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f85713183d56743ca6644d89dc69ee413c4744213c8729ba4acb2912f5b0e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end