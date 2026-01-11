class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "06df1312108e18343b48fb3e76b1b8938a6afa1e0c5971fb791f135e00182e65"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7146cf78059f2e2cc556dc1d5837e4f9c69ec996da823fd2b198c6f9a9a0272d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a590350b22192f78b344dd85bba03d83165e7d89e20bd4db9e44ec2f49726a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e0e95b69ecb0958cabbd13d192eb150d900bc7b7f131caa2572af9b72befc50"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cb89f1be3787b2ee2654f1b77d86b75b46d21f27db89b58da4bafa1ac1ba322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f690fb2579df67416e2e6785b9fb7c7050aaad94b1e5ac40147e7ac65ef9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e37bf588c5b6e9110b9377716e3f0e911fb16ddd349959b510e8e97101f1c6"
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