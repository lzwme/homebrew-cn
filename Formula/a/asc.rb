class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.38.2.tar.gz"
  sha256 "1b476f9fcc06224463d08cc5a80523d2835267fa45761ff56cf316b462b5c8ac"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cacec89c5aee7469bdb124aa5c6a24b4f3fd4c4904d2ffa730ebd88456005e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426a41f46cc7b6272da91e691db6dbddf3d62fe115a60a475e3024b3e81b8c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a951fa170b80fac01e61645e6ea223a3993391430a729d0b4177c1da2656ce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e301224e2f80b96dbe17ec994456315493332f47e7d60141b978ffd1642924d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a92bedb75608d1ff8059e78483e982b784ea2355d5aa9cc8ea5450319ea4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f8ecd68361131b11f22becf8b427a8c228bacda2a79e8a1dd1781806f8fdca"
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