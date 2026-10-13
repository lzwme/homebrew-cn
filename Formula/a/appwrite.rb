class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.4.0.tar.gz"
  sha256 "25e980b965ed370d17dd4acfa70bd1bc7434bdf946af059bbc71e31511fe5886"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb757dbb9143dded13fc70cf8ff8f04568a3c8a51ed12bd7ad4cbbc4817542fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb757dbb9143dded13fc70cf8ff8f04568a3c8a51ed12bd7ad4cbbc4817542fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb757dbb9143dded13fc70cf8ff8f04568a3c8a51ed12bd7ad4cbbc4817542fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7fd0564791af768d5f07349ed7ef1ac3bc1ad4e1652b6a15553248d8cf7a15ad"
    sha256 cellar: :any,                 x86_64_linux:      "1cb5d882af8ef18a1a9ca3e9a0c955008efb58de658bfe4231a00e0809450595"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end