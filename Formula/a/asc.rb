class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.17.1.tar.gz"
  sha256 "72848336cc25e848c20323c679990e969e9d065ae06b852c7200b177d907b364"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "149d93f4539efc6b9278cd7c848880db3d5fb3dc9e505d53c3932da303f051d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad2bfccdd2f73fd6345c66d98f4e676ad764f8a2b1464fb8b54dc41d85fc67db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "767e5d03c8880cf2ad3b7722b1c4aded047b525029a343fe3f6c0f1c01956468"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d74b2efd2b3df381ffc38557b44578a70f3f75a14cfeea1b4a5b201daf277f2"
    sha256 cellar: :any,                 x86_64_linux:      "b40a0cd2f5d4d0f2902322ab14404341948df9491ca06f6d5f8c9111dfd1796c"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
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