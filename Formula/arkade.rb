class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.9.7",
      revision: "461fb7a9d05d7e3d13a39e03e1e38b6936cb15bd"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efd96e321e2c134317977586d70eea66dbf8be0b660e14c317a2f51c58099a58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efd96e321e2c134317977586d70eea66dbf8be0b660e14c317a2f51c58099a58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efd96e321e2c134317977586d70eea66dbf8be0b660e14c317a2f51c58099a58"
    sha256 cellar: :any_skip_relocation, ventura:        "1a88b6537d1da225f121b71302926e47ee75c8c46079d5bf3e37a8d2db1a9c51"
    sha256 cellar: :any_skip_relocation, monterey:       "1a88b6537d1da225f121b71302926e47ee75c8c46079d5bf3e37a8d2db1a9c51"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a88b6537d1da225f121b71302926e47ee75c8c46079d5bf3e37a8d2db1a9c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad776fe5f468da562cd4cfb7ca9d0ccbd6bcfefc9f5b957b27e6fc8cc09a4811"
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