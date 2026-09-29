class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "0f6f2475a4db8837efca92ba65f18a2d8416b4ed5aeb8a1ef5f006e19326e888"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e7a8810733972099446f4b91a59faf915904d20687a34b6c66b0b8d66157e2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f474c27ba9f75f0fe1718b24cdb5d1c4c2f214b757bda7e7115e226e50fe78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e924280fe36dd0f76da325ed114cd3e0fcc7e087c59282c90ee2c7b8ee2e002d"
    sha256 cellar: :any,                 arm64_linux:       "cc3b91f12f4d1b097e9246d0f64ea6f9e64bfdecc25e1a53517ecec2b453cf91"
    sha256 cellar: :any,                 x86_64_linux:      "2a616b568307ba175b08cee8021b3576b1f965ec1984688babd6f61e5993532a"
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