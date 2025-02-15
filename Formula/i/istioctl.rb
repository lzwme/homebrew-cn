class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https:istio.io"
  url "https:github.comistioistioarchiverefstags1.24.3.tar.gz"
  sha256 "28c93f65f453a725fd4ad4e5f37053708a0be7f6450be35270f4ae8f45cee725"
  license "Apache-2.0"
  head "https:github.comistioistio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a35b7876d2eb5dd84275370f9d3a5c659fe90903bed0a20fe6a58565c0558708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b176c3488e29e383bf9ca7dc6ff6a49e025364403bca89f4836081c4011212"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79ab437b49e72248a19a0e81ed1f8abc0515a25e43902ffd4a7a353c0fdbc795"
    sha256 cellar: :any_skip_relocation, sonoma:        "76137ce0cfb2af6c7e29ddf1856463bc3d6e5f81487b279dcfb0fc2d1e7949b5"
    sha256 cellar: :any_skip_relocation, ventura:       "c96aca83844bac2d9511e9c64259ee97b027cc7fab6e62c297f2a89cc518501d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ccd0da4154dcab6594a974565c209a40a9a4735306b5e4d3e5f7782f04157d4"
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