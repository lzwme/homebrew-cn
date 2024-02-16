class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https:blog.alexellis.iokubernetes-marketplace-two-year-update"
  url "https:github.comalexellisarkade.git",
      tag:      "0.11.0",
      revision: "d6c8509191b2a1893bab8ba71612643956716cd3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1ac9e16ac0d3b3d1f311f1d0c158709bd971a461812021197c6479ab81651ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeb05157db3519bc55acb788cedd756a1fbe81a2060cf3207a6b87a2c55c0070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ab08155b2f7551e317da27a3d99eac3287b6a90baf40393047807da3ebc5de0"
    sha256 cellar: :any_skip_relocation, sonoma:         "928568f2213bc6a8abd46392128475de7bf51491bde642de2a23cfcbdc4b0a00"
    sha256 cellar: :any_skip_relocation, ventura:        "bce962ccb9f54a8afeafd7d6b6baab3af63d763c6e34f7aa8cd67a3259901020"
    sha256 cellar: :any_skip_relocation, monterey:       "607351c2f7558741846e23e032f0ad020813ba3cffa48469fe09655539c3b2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152402cbffc386609ed480dc299525fd78bb55ae3070936bc71cf0ea5f315234"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comalexellisarkadepkg.Version=#{version}
      -X github.comalexellisarkadepkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin"arkade info openfaas")
  end
end