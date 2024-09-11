class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.23.1.tar.gz"
  sha256 "a3e38c189f4bcf01ea42d3502511e1221456f78c1ca24508534b4111a43064e4"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d94abc11269fd9ec5d9865e318b23ae70c32cbaacdb370e91fa5ac258026529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe7d63528ef12bd50518341b9bdb261fb144cdddb84ba3e02140bbb6ccac6843"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3bd242dfba512cfd62f8eb325bd293dea988a2034336d2fd6a72ff51ceee86e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4122198279283f72bd6b0d0221ca0a27b756413126591f8a843815507f88e49d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b8c6bae59c43018bb0bd44f01c27b0171f8c688d12285fbf8fa70cd01847d41"
    sha256 cellar: :any_skip_relocation, ventura:        "e288183b9f28721d6d59b557140cc44d2d3720827a834928a5d1c73ecfd07fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa92f209e68a170b17fb97543678fd4ebefe276bf149ee23067a1fdcdab8ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ede8b7ea425dd6abc05d2a6ca4b288af4798ee08683daba1a1faa8cd5fac93c"
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
    system "go", "build", *std_go_args(ldflags:), ".istioctlcmdistioctl"

    generate_completions_from_executable(bin"istioctl", "completion")
    system bin"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}istioctl version --remote=false").strip
  end
end