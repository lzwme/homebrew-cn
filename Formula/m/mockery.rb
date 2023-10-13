class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.35.4.tar.gz"
  sha256 "f50c603bee265e736510000001dff49ccc9b332cde4b245be390f4e74c3abd34"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8e41d3a3a8f5a43adb0a3fa210b4510c99a8da850a766ab9dc3a5f16de61927"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e200c0c9c4707a22456d4285d9f4a406fdbd4e79221c74ef336a44a747c52aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b48f0caeb8a0ac50b7d1ff75af30d301737c62787d86017e38676565e8e6b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a2fb7911533518d4c3c7ed092c852d2a972ebd72afadb7eed91d663fb63736e"
    sha256 cellar: :any_skip_relocation, ventura:        "95f0984005abfe6c2d790b32cb0397b64eb2bc4c57b43158793bb17e0413e450"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6bb77b6b0aff22de92df26e4db01f73384d9453edf04658b2fc01dcad9293a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3e71279db1b842c566b5854961e571d98c552796757fe1f36783993c68b9cb4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end