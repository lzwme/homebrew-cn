class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.45.4.tar.gz"
  sha256 "428211314932684a997bc0f932d1b008b9b98e29e30cca79648ebf0c4df656a9"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17822e717a62190d279b135f5ae3f7f23b50826a9d424f66448a0e63916eacaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb35222dfcc7b885874c2726428b75574781fc5df4f4e3b22c4a49cc0fbe6994"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7273223aa1fbe524057b383b75c35b1188a73cf9988439d4a57355c2ca72649"
    sha256 cellar: :any_skip_relocation, sonoma:        "44065973853382bf19bb966a51dd6412eea907406e34f86015410c50e47952fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ec8fd76343bb0376d834822f6c0be18837cb4cd14cd17d946f08b79a5d1e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f7418e480621a3af30962566acd0b31c493ee6bb5a9bc776da533c16b7440dc"
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