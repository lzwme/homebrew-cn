class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.24.2.tar.gz"
  sha256 "642b884f5138b76d02b1368349d986492033f2bf3edaade0f2e2a0536a9ee14f"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b45e13927be2bbeda13bd2275aa2132c27c34ba9e61413723a86fc5d5d908185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd959d44b47683a9477b67b99b7c9d28d5faace593dc17fe21e820380c5e8f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74baea0fe98555c4e261a11ee6a52b5bf5e8e1160592bf58d93d4773a8f45c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f9b311d118813888452a9a385d24bfd0adb30d628607d918bc860904d3de68"
    sha256 cellar: :any_skip_relocation, ventura:       "462d563d22faa6983ee092555f7465ad11d4bbd92b56064c05abe4687ea284ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4afe721fdd8cdde69ddd60de78da176d88dc1adde5b85a55e2d34cd7108071"
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