class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.2.2.tar.gz"
  sha256 "32e4da0a10189210458be9f112034549d8eb7583ae5ff0445fc9d30e8b69be3a"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be8461a0788946522586875c5e7bcb6f6495acb48692c331d04cb783f61cc437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff6fa3c0754980274ef77207d821936725d50db7ebd148ae3e30be4bd91c8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c0198431662aedf99fce1c7b56198e682f880cde14f0a6b9e7d8cfe46004fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "31289f7a317a821d8dd00e00165d4a673cff73bf3f998e9383880d063a065ac2"
    sha256 cellar: :any_skip_relocation, ventura:       "bc2e028a624f780f0c4559069efbe8a1dbe48fa257bc8bd2a61b4b5ade7cd30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076876c73d8b3e4b16eb62514b603ec56676ea6fd61ea04aa77994fdafd515a8"
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