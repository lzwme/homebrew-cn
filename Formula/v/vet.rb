class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "2735adc30a0f962dc7f78ef2c1ec4f3708a6454949848c6f2685d23fd1ca26d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "637ecca5cd10db57b5728875d947bb83d3852ec5c0b36660c67e7f14c65e8a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b278c4e153d4461f26d2c8a213b9b77f48529d8bf7144cf8897b3ba966373bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477dfdf2db590e8c0a6f8b4b394dee1d87da76742a7eeb0e519439cf9756e5d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bef47c26568644f10d6d53d3af62622b0a199f252b75f6f912dcf800209a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2691b1801f9356cf33b610f90e7f5a20203cb0ddc1f694f23306334ea104eed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e5f64113d5a96986806242c685b3f4cd38828380725cb2d643773f08918fbf"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end