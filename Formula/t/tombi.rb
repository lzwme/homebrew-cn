class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "a063c30086a6c7e56be91dfaf2106ab26684b9ae5b1fda3c014cde27b5ae1455"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "496114e7e7bc8ab3d3b5a2115f6eda8ccd9027563469705ccd4a8f1167fa8019"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ae5b3f006f98fc53c73d671ebc643f5dee5c1874860be7aa833b7ac468fbdac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "292a14af5e3db07313b063e9a588c1f73060799f62599819f3b3cb5da60aa901"
    sha256 cellar: :any,                 arm64_linux:       "792500b02b6f61526362443a321e7a98a3cd763934200c03fea28aa58cfaa7af"
    sha256 cellar: :any,                 x86_64_linux:      "4de5b35862fe16f8bf68675f5a231ad8248bb5da31b30a9620c7d063f0b78f00"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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