class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.23.3.tar.gz"
  sha256 "49c0d3b6b6cb99a0b628d30b92a22439e9a9cdb78a1b8aa44c53bbeb0c9f9991"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009269f91f4f472206439f680e47eabfa7ac517fa5458fc633f57a2d7c408933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8e4feaafccf7a1090fe4f64b53418083fc584da39a92a33cac4f477db46ba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fcaa4a42a5525621c3f2dcf6f4c9b039c4dda36fa611acc10ac3ebb3c3c0529"
    sha256 cellar: :any_skip_relocation, sonoma:        "03fc3e5322a3a74498defd6b67b6239d252138ba08a9c56a14d655cf286c51ed"
    sha256 cellar: :any_skip_relocation, ventura:       "809f6b540075a95ba55df72b61ed7a230b30c23962ea79734fa73979c5ca9b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e2fcd6b449af189fe76708acc17333d48587432d191c9c14b847efc1fee892"
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