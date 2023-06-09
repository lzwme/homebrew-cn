class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://ghproxy.com/https://github.com/vektra/mockery/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "463c1310094908afb1f921a2f3630f6d8e6ca3989b92c016fd6b33d4d47e9f02"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c63f44f233040c721390bed3ecb7336abec898ea53f933031857500092f77671"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6d8cf6208a22d285f5f3599dbb25caecaefb633c51779561d3583601361823b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8de447eb45798dcd0b78f4abeafb9d7d14e92f14567cbeaa34bb6924d4bf5e9a"
    sha256 cellar: :any_skip_relocation, ventura:        "4b736df0b0da4a20e1fefbe869227e9639de2a437490391a48ed92b7b32ee679"
    sha256 cellar: :any_skip_relocation, monterey:       "aa82e61db78fb5db5b4e2da39f41d5ff9baa3652e48f4c07b91f6f5085327655"
    sha256 cellar: :any_skip_relocation, big_sur:        "03dad076f8b4020a01aa4727198224b669d0742dd133cad80d338743bc3ca579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db2f4464ed5cd88dc3578814bbc1167875b0d72d16a09455fb1fdb11668f9dd"
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