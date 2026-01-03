class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "a9092216c396292972d6f4d83b55f1b3688e6c3e07ed6251ba77adc4dc34c039"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93cf51c22a69c4fc89724129059ea6d2f8b9a09b7564cd47fe46e8401ad5a3f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93cf51c22a69c4fc89724129059ea6d2f8b9a09b7564cd47fe46e8401ad5a3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93cf51c22a69c4fc89724129059ea6d2f8b9a09b7564cd47fe46e8401ad5a3f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9986cc73fda296400317b3efae6b792829f017216feb187eb5be2bca7614be43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20bd7d5bee3667f8d962a7cb964025dc1580e42cd276957e139d436eca4f9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d344f77f628f9ed84c459e85834b82bc8a23a41b363047c409dea64e0ffeb28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end