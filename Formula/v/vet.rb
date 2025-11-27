class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "9cdd8183a1fa3e2b1c5c4f756cfdb525ca2b43126a57f71221d51618d000c84f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "442cde600eca9fe5d6a99573d36756f3f4932ccf00d8f648bf656f2bc4cffcb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c8436fd7792716d1f694a6b9e074942c694adfb98522607f805f86a69817882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c71b1870504dfab027503cee753290591fbe661c2641702a422e6b75709a573e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5addd90648166d85c773d14122e734013469e1a3bf01a50efce3e4fe4dc32473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297b83b1dcbf84ba55eceb8cd169de495f579e46bc1c7b078e8dc09c07c4931b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d5ce3b1583660145abd1a7ec7382b6d1c3522d85a833aa0af605769a8c9d608"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end