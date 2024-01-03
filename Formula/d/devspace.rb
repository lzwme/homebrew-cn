class Devspace < Formula
  desc "CLI helps developdeploydebug apps with Docker and k8s"
  homepage "https:devspace.sh"
  url "https:github.comloft-shdevspace.git",
      tag:      "v6.3.8",
      revision: "8976e57bc4dea237ce3c83637e757b33661ed4eb"
  license "Apache-2.0"
  head "https:github.comloft-shdevspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8ddc14e6941cc73ec07e519b05905e7a76e63426225d4d6a388c17d7bda9449"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e47c2b01e2205d3e5c45152d6d132b7ab21b27e7c2e15ff824b7516b786fe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2bc9e27c405a97d4cef974db9b75a9148767f7e47e9f6d70438c3bcf64aa0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8cf772b335e91bc8dd29ca76161c651d7f94a5cd97569a4365adf971f7cd371"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca79cf5246991abfa33df96a086871e1e95f9f7cdfaaa0be7639179ed3083fc"
    sha256 cellar: :any_skip_relocation, monterey:       "700241631f679bb572b7b0d356e62015ce6d93e407b186496c33fd38bf0cab06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65655963bab5cfd1d35f00a36ba254103ca3d9926e6ea7c1f6e396f2b44dcf3e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}devspace init --help")
  end
end