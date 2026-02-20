class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.29.3.tar.gz"
  sha256 "51247c478345d6fa54496c408c4d4818058a9f3278d9d7b5d66fd33979ddc8f9"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e421d1b10a0bc4cf6dd95f800fac31b7298911fc6d19af645b1a0334fe3c26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8b8ff4ba676c3c6ebb746804dfd954d99425b3fba0cef77ce42c72b06336d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9458e82ac15cec03c09034233d9ae2f0b6fe7f165de333a837943b80e41ded40"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3f91f3beff396b33496c5ab9baaf22dc1a66bcc57f0108e50d85303dfb9926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b82b10e776912a47a7cec34e373c8434efcda5b45782cd550b0f18b35695ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d01ada950fd1d3e22c8c9991231fa7c9179f01ee07d6c07d2b19e26805743c0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end