class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.3.0.tar.gz"
  sha256 "39f14a319a49e6d0b0093f620d77948d0ff15ae5c2eb2a559f543be44f937b87"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8bee12f8b0fdcaf1bb0cc53020a921f0272305f88676b526ed45803d1e88c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4234c415f24e2a4163217fa98d3f07b815e15dafb77ff9d60a033015d702574"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43199e6158295a52c7323c64685ebd4fc8dd8ab3033771a309e1debb4ee60c4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "17afb9b0c220f173e3c41097f09349fa07b17152a6f67cf8737e435cbc90ef2f"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d3aed358fc6aadd6fd5c39d10c69c8c10ca747600a80b945ecb30878cac1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "250f1cb54399d587cc3e76680e50ff8aa42d4615ead5e1375ac16e22bfd8cd74"
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