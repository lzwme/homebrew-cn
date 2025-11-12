class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.57.tar.gz"
  sha256 "1873e1ab0273a26c60c4d3d12e2bd058f86577fb764da5c576438aaf85a99c3c"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a37361eea6d8df0671bfdf3c4e1de49310e5816b3f7ea6522ee8b9c4715b09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a37361eea6d8df0671bfdf3c4e1de49310e5816b3f7ea6522ee8b9c4715b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a37361eea6d8df0671bfdf3c4e1de49310e5816b3f7ea6522ee8b9c4715b09"
    sha256 cellar: :any_skip_relocation, sonoma:        "42bb2818b966fd173b46ab1ff74c96299ed4ba1a7ecfd0d890ce2c2fed64b129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941a2412b15d2b434743f0e55ad4dbc9406a182a75bcf508f4ebd1edbb31aa96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aadf5cdbd3c264452e7f020c89ea4af8ea6c2c0d5ea7e94bc24ca8521bd58242"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end