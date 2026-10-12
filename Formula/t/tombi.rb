class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "c95531ad3cb68ad6d5c5803d4771e05ae005a65c8d28d328b76d6148d2d518c9"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfb170845d7000929eb23d563a2b388bacfbd52033948c6ed3532b40d5cdd2f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11a2b0dec0d780ffc70f1b5f01774114ea41cd63d717e2cb579258cfeca47d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a62412fb52be4ba54be20e1f6d4dd4c92aae0afb6a4076acebeba6bdb8b547f"
    sha256 cellar: :any,                 arm64_linux:       "a555f457127c05ad96512d57946c2840cb0bd07d1b3f474b663c139633e028e3"
    sha256 cellar: :any,                 x86_64_linux:      "882be5334ea6e8f55d92f22b310d5bf68d817b536c2878402efe3d4af8f09977"
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