class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https:github.comyshavitmdq"
  url "https:github.comyshavitmdqarchiverefstagsv0.3.1.tar.gz"
  sha256 "b6bf39ac84363ed4e750a8342ca609105a8c0b84b50e5da6bf3be4130c367d75"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyshavitmdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9d7c5b3ba70240989aa2f213a252c632bc0914f0c735db9fe8c58d67ac77ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d61242a7e6cf0a1a1fd021b46b68bb3d285dac793ca1568d16f0c3a5e3fbbba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f7106be528ed1ea29886936c698d507ec51f98ce846bd2cc23934c809e45a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa4613f8889327a29caf91fa96b82430dfeb20d321f2a1a7ea7e3a262d6f7aef"
    sha256 cellar: :any_skip_relocation, ventura:       "e203fca1c2fb4de712eed84f81860ed88ab46a853230b007b699612f1a7a236d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1142d0a1c28be0c80e21dbb6be985f40137a8329a2d8c3888e3e9d36d2fb7994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087ced9427eb7359c190fb4ad507a7db5ab364d6a9fe2a188b91c188bc0cd6b2"
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