class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://ghfast.top/https://github.com/alexellis/arkade/archive/refs/tags/0.11.54.tar.gz"
  sha256 "e65686a035c299289dd61d09e051db3ef8146e27e31daed0bffbbb1c35caec01"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c1419dce24e47fa7e836119ca91fde0e5d303634b8ec714b5220c8afc11630f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c1419dce24e47fa7e836119ca91fde0e5d303634b8ec714b5220c8afc11630f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c1419dce24e47fa7e836119ca91fde0e5d303634b8ec714b5220c8afc11630f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bcb3e4c7694328fd375f2546885e8172883ffcfd208150b5b8db13f7e96a9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7ce998528bc0fa0b95bcdc7f043526d05e692ce502ea8a99b7035b16ba67640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4581180bb9e63b596d4741c11ff4486acc792d2c60902f044cb90099869bbbb"
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