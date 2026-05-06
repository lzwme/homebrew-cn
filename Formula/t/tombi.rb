class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "48250610d8bc5f4c7b4b219bf0bebad3f7b42a76773258981c79d3de677fe157"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb40469f04b41a0df9cb413eb534c5dd6e5f79c7cb750537fb86ec665e9b3019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeca376b40048c5958504842ec6384606f17df52f78b967b93f950d349dc6d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f0d9693d23f870840eccca3f08cad840541864b0d8c0b34a9e11391e43e5c7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "59191be8327f4053708dc63942cc2f14d28c72a685173d690b0b3d84d7476224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57791da784b335b3366ebce49bc144acbc10d91dd729d49948db5568b567f0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3064a43a522d2b6f47bf8fd4305915f293f93466daa4c015ee23ea9653313ec"
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