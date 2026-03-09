class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "bfc0664b846c434fb66b81e40486ae22a0dac569543a22e40f62fcf32ebfc259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7034ab4595f9638c38a619d0a4f613d7b6d28d4e64b5ce1a76da477b2f913ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7034ab4595f9638c38a619d0a4f613d7b6d28d4e64b5ce1a76da477b2f913ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7034ab4595f9638c38a619d0a4f613d7b6d28d4e64b5ce1a76da477b2f913ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "de162ed51a015eb23b1f44525d83d6e2ed18cdc5ba013f11cfb77d96c4510a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e13d57c9bc26284e5e39a337a15ecdd5e126e86d4890209b07220aa5b79081e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a3a91fc7c778675d29cad81a0fdf3f635a381d26d5046802c69061fee13480"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end