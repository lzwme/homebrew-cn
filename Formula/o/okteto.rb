class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.14.0.tar.gz"
  sha256 "ac052a6538a5a4475159db3dcf613a9af5de2cb04673ab79c346a70bc02e9ce2"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcece5f891f5df32af3afa3b0e39c598494a550f3f0c34e409290d7d077fc629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "600e5d75a91ea781586c2a62ebb59d32194471f950e88cc4324cde5b60079fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d489f327aa59af1723ceb458254a6fd9bf58ce879bdc7eb950ebdfa4f8bcaa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "19570bba01200c9ec88be569d5aabd7e48784d20f6a962396efb719fb76e42bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333b28ad4db37bba95842349c4e509fa69002d25fec8ff3466fb0227c61f3e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4839613194247fc70140506ce343bdf9faee2013a38d96afd3484ef13a417f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end