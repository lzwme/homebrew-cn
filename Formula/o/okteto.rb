class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.25.0.tar.gz"
  sha256 "e79de95b5a749a35d383cf545bd96f6329aea0b0e32c08f2c1e982af45d946f7"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0dbe303029263b5f40c5bee552b2b2af8b2dd5bdf80f9781ebc1d37563911d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2beb238af5180e6beb557fa570b8f97f970b6b55d1911b54268b6361c8f41994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f24de1a5bff34f4cf5f2de59cbc45364aa8f6f82bf5cf4b4aa28a8e94b396bf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f068bb12f899d65cab4d5e0dfacaf541313ccc5889d8d54a0a046d75753006e"
    sha256 cellar: :any_skip_relocation, ventura:        "14e7fca12254ef95f0c6727a17f3c4341df015916013584a01283728f5c34146"
    sha256 cellar: :any_skip_relocation, monterey:       "5be4eef6413810eaac85a588b774887c6962abdd9c0e3e52b1c40385f60a0aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b867901e63569a0d59585a44b70398d4bd52d477e84613d1218e5486e3dca5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end