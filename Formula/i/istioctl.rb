class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.20.2.tar.gz"
  sha256 "4d00860db00c358f851c640fcc59f714977881afecdfab6f02ca053353ceb0f0"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a766525a8f0ce69f8b757b63c5a140ea41b845862a76905906a98460f021cb28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe3fedf3c3a86ed7223c11f59bbd84e14f4c56ad090df33faa5a9f420c3d04a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7be502a1a779fe93f4eec6f87f695a2d4249bdd8872360e528a312703a127204"
    sha256 cellar: :any_skip_relocation, sonoma:         "216e7e360d59512db5800558fa30efe482c71c9755c30fe351a21f550eb5fd9a"
    sha256 cellar: :any_skip_relocation, ventura:        "ff59c326dc973b8def16a9228b24545753383cfa8630040f17d39c8329751934"
    sha256 cellar: :any_skip_relocation, monterey:       "727e4c51ec8003b46f676779f6a479afe35f38c968af8ec83177aa20ed889848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3085ad008941aa34fc9a6f83ad5d1759999fc467b099cd98daeb2604fc6733"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.ioistiopkgversion.buildVersion=#{version}
      -X istio.ioistiopkgversion.buildGitRevision=#{tap.user}
      -X istio.ioistiopkgversion.buildStatus=#{tap.user}
      -X istio.ioistiopkgversion.buildTag=#{version}
      -X istio.ioistiopkgversion.buildHub=docker.ioistio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".istioctlcmdistioctl"

    generate_completions_from_executable(bin"istioctl", "completion")
    system bin"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}istioctl version --remote=false").strip
  end
end