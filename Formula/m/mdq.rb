class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https:github.comyshavitmdq"
  url "https:github.comyshavitmdqarchiverefstagsv0.4.0.tar.gz"
  sha256 "e994d67545929f9e14bdf26e7e7f82fc190be317cdaee4de0f6125b28c8911e3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyshavitmdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502446e3fe349f5b3bd05ae175f3e283a9cc9885f74f115540972491799ac462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "053bc88263a042a0e82b814392ffe8d5e0a588ce4c93b0df45587dddfee4c313"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05bfbb3c2607dbba5c8da69712337cd82c2f94a3b65dfad99c4f5df22539856"
    sha256 cellar: :any_skip_relocation, sonoma:        "c82645bf32233b9e171f02bb7a50e7345334730fc33c6e019ae83df8a6ca52c9"
    sha256 cellar: :any_skip_relocation, ventura:       "bb43f0e0355a2a5f4b6166b00f95a981b63135d8aac998e8170077a0608d9d9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c30f91b7db7c7250ca15006ecdc8017c242a4fd5a6912fd979199b9af0bc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe61fe264b76c3e69c90b5d70f0082868ec7a1d9fb48c15a0c98313b3cb89b8"
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