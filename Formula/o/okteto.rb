class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.2.0.tar.gz"
  sha256 "75734275b74d07172648f88d9b09cc73ffe8166a008d2df55051f86680a78335"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b2cc66becec6481c06ffadc4157ac5e765c3f6c38d7db3443a47855ddea95c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c72e5fad5a348e4c82a53421350d02f0327d7c0092948eef4c92135274e515d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e44efbb323d69c1babac6f9f657296de92da490292af549edf8047aadb42336f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5721e5bca9d7352d3af3ece72c25753e1d16f810c50e8ed5f7af838d7fcab0"
    sha256 cellar: :any_skip_relocation, ventura:       "8074cf3afa7b0f6b56efbe5ce63f97b08d51c6c4e8a4e94f2c0d49bbfb4b2c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffdad86f9fa84778fc5b611fa0b986f7082fa36ce3c8e661272c18b93cecf5c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Your context is not set", shell_output("#{bin}okteto context list 2>&1", 1)
  end
end