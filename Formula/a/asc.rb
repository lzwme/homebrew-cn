class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.6.0.tar.gz"
  sha256 "6da10c56e810d11f0d14b89e0cc8ea64c05459cbcd42784f53838d60afd042e8"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5133e190699fabd9b58496296df94eeb62e5013d8c4a46ee589caf7e76d7d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4c90944db86ec02f9ef55e10f8d617ac2c331cacf5afa48e17916f18d67ccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7febe7cb22c371749c5273c74c9a1a6e2ae405b4c765a6dd6532fbc76f2118ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "298f52724729bb5b49eb741dc25a5cd40ac972c7ec71136d2f11a64367950ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6999e45b1f84f7b2ae40106942972775e631458e7c817e9ca7b5455c16d909cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8768e72f11c802257d6cc89a615a26d8c4e3cd68bf38a4d1bb964d32d83fc9"
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