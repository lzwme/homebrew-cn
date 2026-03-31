class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "1d33244afd0268792e971837896514f53534cce82953d356d5ccd941f0877424"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8922c5ea3e5d8dd9be027f2034a7786def63549c4793b7fdf4213c599ece5006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990d64e9d55566ef323824477439e3706a78e6a06c6311b335d15c07619eb11d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6702b54d39df9b3697f15a3c0b65d71e6217582263aed01864a9118f14f2f9b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0b21413bd253037eb13acf257d6c0adc81b133b100b72cac38b3732daffa42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d2ad72f1071cc2279d626b8a5db0400cdf34b2e92f5bdf68a19636139cb3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc3df0596174f296ac0b81eda587f848be2ca540fcbbf252821a734a218e150e"
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