class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.26.1.tar.gz"
  sha256 "e0e361cc3b0acc02a856829145d3d7561f5d4cdfcba1a27210089457e3e919fe"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "968fe6d9b83f6c66956e25bbd1f75680e38790320f05b57b8385228ca155c8b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "543f657fff789556027c93b5dd9579d2c725ad7915acb3034fc048bd7ec35ef6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "958d4bc2d532916dfbbe8e2957017c9ac56196f22c05adb9f24512aed65f51ce"
    sha256 cellar: :any_skip_relocation, ventura:        "d308de6d835088559daee43db96674ca803bd45e8687f1cc7ce98354f15ec5d5"
    sha256 cellar: :any_skip_relocation, monterey:       "dd324c463bbe2006f857c7860d8683a47cbd25b7c41a160cee3b17ec27dc3430"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d8d3c02e771a7674e9c3b7c76c6ac14f6c70a8cfd8943309e9683421fdb6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b50ae958dd7fc254bc5947adc9c1d9302e5d9075adf70925609d49109b91809"
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