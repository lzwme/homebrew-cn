class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "cf67ed8a12649d7921dcb4da6c4765f79577eac1f84405db14f802ecbce719b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72ad2544d65131ae6f368c7534eca33bdf71e2e45983dc03340af0c26de29843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8d536dd59460d44f7441d6bb80c1058b41fcf64410e8d297ad0dc63644ff3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65ca02033f50ed73c40e84c01ea7ef0b952edfd4fc2e18f7c12b4ef58566bb10"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d7d14f8e3d17c4f1cb63d98c1ae1c0cd51d4db6c5270b11d37dd7330781729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fa947e9095a60966fac913dfff1757c87c3a4a7e96a50376f43d8ee6918892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b6d76c6841727376b62fa129076cde5c91f879bd7c9946fac12e514a473f453"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end