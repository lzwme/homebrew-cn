class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "65c03e142aee0d2237bfd4ab0f30ad2746dab4ea62c81d365d6a505f4df4584d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea1c7159387937f91a8a8a9e290e81c49c3719e1277989877dda5db7f32f117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea1c7159387937f91a8a8a9e290e81c49c3719e1277989877dda5db7f32f117"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea1c7159387937f91a8a8a9e290e81c49c3719e1277989877dda5db7f32f117"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5d7c1b15144739e4db1d848b6624ef29718dd06558f8973be458fb37f1cf3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5075584bde738c62808e4e4783df581112f3a7f9b5a34c6bb2a7f9df98c7d53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db2bcaf9b9890672ffa76715e15b5e5956b8aacfd7efbc414f822bc3743d106d"
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