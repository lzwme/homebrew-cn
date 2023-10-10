class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.35.3.tar.gz"
  sha256 "0655cc0d43d72d14e8f35b0fbd23809bd2d8047e2dfbdba07ad441a663c60cbb"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e45177d80f5c014a809215d50c0fa89d097b66d004f1bce1c725d628bc42d1b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dc9e347db21d359145faf525d369eab4bae767b39e56a73783c664f316b5f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a288f17c0982fb3f428433b9e8bdbae07916028ccfdefb6bc4901e74d71733"
    sha256 cellar: :any_skip_relocation, sonoma:         "f26ab848c3fcbeffecb9b6f6a2476b3add29ce0485856a9df7588119186ea6bb"
    sha256 cellar: :any_skip_relocation, ventura:        "a64c9cedb6a546e001658cc3dcd8b5de370e639c526cc70b7d24eb0bcfb25b77"
    sha256 cellar: :any_skip_relocation, monterey:       "5203e36fb16045973aba53b17f0aaf29242704a85a34c842af4c226b5b38c5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f6ade9adcfddad1247c1d8a7a1eec069804d17b4b651f472f984864cb7e2cf"
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