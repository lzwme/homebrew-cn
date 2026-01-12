class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "49978ceed91d535e333d73668b269b12666894e116bb1cd5ed2ac9601e08506b"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b44b43e29810abe2d7c7efd44f3f9f36694eda93efde9abcd6c9266f47f9f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e864c595721fc519508ac7a40b175d3db175b74f7a2d7770d0af3ce0edadc35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344bcc35aba9fe422df874e78ff1bd997e3571435b0124f2755a0ae0ec427043"
    sha256 cellar: :any_skip_relocation, sonoma:        "f026f1c55e5f25d25b701edf6c51cecfc5f93109fc521b6de7f647b67060b673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b7b0376c606e51ed9efbf36178fa17ca25178c07133d3c4881d45331ec254f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d063eb1d3c349b70779545f6681149530691eefa037b98e5706d3ba979dc2153"
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