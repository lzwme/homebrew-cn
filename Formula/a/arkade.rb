class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.16",
      revision: "8363b67093b15fcab8241770d4d843a26765f44e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4305b123ca14bd09727703ea5a0df6425d314e1bfe8dba4af81fed162cf9b74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5275b385424041e252b7edf79c22d32e33a5f91e25ed95b92559f39cf07656d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872553cfabf4868f383a6380b4e0d505e508f8dc522ef9133d4abf312ae052cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b03b127edfd0975d104f9d0621988d9255b6989357d65cf0f8d4a2d889dffe7"
    sha256 cellar: :any_skip_relocation, ventura:        "192da67fc707e87ca8ad0110592eb2c8edf3363ba902417087a5091b7ce8a2ef"
    sha256 cellar: :any_skip_relocation, monterey:       "60b2fd7e0092732a166c2884811db6869f85151306c26b5f23576e2ff212265e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b88b67d061b6d64170ed813cf576e71b4bde95cf8e86d5bf5d39beafe0eaa44b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end