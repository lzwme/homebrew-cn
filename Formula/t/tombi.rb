class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "4cd7179e8e5cbfc4830cf60ce523936439b9637201b9d7a9c16faa2e71d4f751"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ac805173de35aae33c77628549571307598c3d5ae9cba6ad249fba6d7fb6598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8965c2165647cb364eb5216019d13adcd04787ddd436f6c96c4435e62bce4d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e50f500f729ad1072bdfd4056ae70b58103fd34246bca05c8e5db68d45cd52df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c8af2dcf83f12686d65c16a0f28e726a02904007f0b6d8d8bab5a4154c2b197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d925fb9988aefd95f44e1d9208a07c783c6f7fda8aa1a42dc420557c92d4776c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77aa8f327bb337afbfeeb4d4a6bb1fd25b74459cef5358a9daf4bcb5a4cf99cb"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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