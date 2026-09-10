class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "baa1b914ce306c4b4361450fbf2101745e5411a978f68fc2d1a5c71241e24cf3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f644d59588df5c66898ac5e0f385c7be94a1e01d96772138ea96d7c5d06143f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaeeeb4e46ef0ec8482b56413e6899913249724abebdc52160e04896d2f9f294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734db29718792a431f866a370f8cf6c08a573bb5af57c32839e953b0510cd9e7"
    sha256 cellar: :any,                 arm64_linux:   "2ccda50de369d057dca1200aedc697394456b7fc654b9f0037ad3ee8af93200b"
    sha256 cellar: :any,                 x86_64_linux:  "89e356e5e25fb9aac497ad4fe68b78b6f7d4424c0dbe0638867de91f7f48cf24"
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