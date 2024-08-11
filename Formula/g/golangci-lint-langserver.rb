class GolangciLintLangserver < Formula
  desc "Language server for `golangci-lint`"
  homepage "https:github.comnametakegolangci-lint-langserver"
  url "https:github.comnametakegolangci-lint-langserverarchiverefstagsv0.0.9.tar.gz"
  sha256 "ad7241d271b9b46b6fc784ab1d035c322bd6ae44938514d69f5ad516a1a9fbfd"
  license "MIT"
  head "https:github.comnametakegolangci-lint-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6e5efc3eeeac36b6d2451bd924441468faa338d298dc98fd699a97c26bb4c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e5efc3eeeac36b6d2451bd924441468faa338d298dc98fd699a97c26bb4c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e5efc3eeeac36b6d2451bd924441468faa338d298dc98fd699a97c26bb4c93"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b61361a5134d4a2bf865ec4fc5c994e1c21a0f9755210eb76ca9e880272088c"
    sha256 cellar: :any_skip_relocation, ventura:        "7b61361a5134d4a2bf865ec4fc5c994e1c21a0f9755210eb76ca9e880272088c"
    sha256 cellar: :any_skip_relocation, monterey:       "7b61361a5134d4a2bf865ec4fc5c994e1c21a0f9755210eb76ca9e880272088c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd46fb7adca762ba9b36bb3dcb9f361c03657d66f6aebc0d3cb2d660f503693b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin"golangci-lint-langserver", input)
    assert_match(^Content-Length: \d+i, output)
  end
end