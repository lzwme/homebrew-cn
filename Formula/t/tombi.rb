class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "284d4226e3f52b9f96ab1cb1793cf6ddd8d21128f4b85bbe478bc1325d81ce73"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcb9d8d46445aec58673893a813e773f2282324dd90d64fd819cb61abdae045f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a220921d27089bf4d35446c934b8807e40bf5d8c02cb9699aca9c75dad2e459d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aeb64760e64ddc61ba29b367c494cc05ee3fe9f616ee9d47186c69eb042a5fc"
    sha256 cellar: :any,                 arm64_linux:   "f0989a2b321e574e2faac7aa2bb61a26b3712c525d960f0d716059041b3031dc"
    sha256 cellar: :any,                 x86_64_linux:  "c511a6cf094fd441c343ec77dd4837fbecbf9f952687208453cf072df8aa3cfb"
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