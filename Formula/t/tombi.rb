class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "1f4dcbd449fea2499a015b0f710907209124e7a63f2e93cae68a6b3ccaba780e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92be1e81fbe41ebb111ca45e8e928cab287f4acbd535e5aa74d9f5876434ea44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9972be92d3f5b0aef8bf17c2d6630870b9db891eb4fb48426b6b5c3d4731e996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4d9d98b5a6feb6861cb0d393ea2d6063e9ad6192fe34afe12760aa8791b22e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6ba571c2ff5a890576656605390e0a25586b1d4b25035ff94bfb346188896b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa18e23016bdd4a6aa6fc1be25638848e0280526f6e205593e0ef7c8b19a653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56386f351248c6006ddeacd031137254271643fd7ef2bd1018f1190193669adb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end