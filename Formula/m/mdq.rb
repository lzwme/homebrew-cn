class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https:github.comyshavitmdq"
  url "https:github.comyshavitmdqarchiverefstagsv0.4.1.tar.gz"
  sha256 "fe3342f223c5862569539cfbc3371183be276a7c63aa259fc03de254d5dd7f3c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyshavitmdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d31c5fc5092eb62c92ba8159f91c78d946e2fe6a49d054dee34521a394267c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bee794b57cf4f6b4bd6c0ed0e4665c728e83a54e8eb45a23ce19dce1feb345e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07ddca2f0daeefb452826d95342ada0e0f337a4eb52f75f3a059c47499290d87"
    sha256 cellar: :any_skip_relocation, sonoma:        "e05e9aaaf9927d0bd209a100fa3f5e83c7bbe409dc98a422c3e0fc4964324ac0"
    sha256 cellar: :any_skip_relocation, ventura:       "d27b573037baf4dd5bf66251045c696fd8fcdaea6bcb0d70aec38ff2cd4b603d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b69a594a5b677ca483c702b247e211e4e5ad9b6046c1a55c8de5245c5601ea07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "678148b1cf58005bf8ba05a8cad33bf04eb5221117abede427ce658e46f8e9f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mdq --version")

    test_file = testpath"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end