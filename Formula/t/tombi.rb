class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "45a0eeba7cb56d0a633fe4fe3b9b600c182ed9b6b98e38e9abdda2d320cd05d4"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60777dad56ff159a552952d03ed346cf838abf11fe568fff3b977f0698b1334e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede2474f7311bcc49724ab9b7d945853b0e9dd927da37438d3c4c35b21d62f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea995921f3d40138738c23311ea05596d80611c9daa98651165d44812566525"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc0cc6f3b0888eef2afb9498e038ce22c9fab62739366298fcf5ef2c640acd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3519242a66e4d0e5d77d54701af885adc443e4ba28a5c21be65232f20eea81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d602b3e869086604c4a638257198c8c2ee002cf1f5861bc46cadf3b169f6d0"
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