class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.22.tar.gz"
  sha256 "ea5ffa19f9853bdee09287f02523f4c797787ace391c02705ed014f091dce614"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a6380d2d5c736135c8629d67a32fc9ec2d443ee024fa332855d4871620c915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821fd2cf7ed2779ee20f88707e758b7e0ef2069fd8f067f6eb567ed65227f893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64ed94de9a95d90faff46ae00c08f970a4a2296153c8305ec13a5ed9b8370559"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a59d5722bb91317b24b53a2da19b45f111eb5b98ca6c89adac5db9702ad9cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84bd7d9d831583920e08fc66f193683412606058edc124d06569a215d2fc358f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe8779d47fccec1def99f94d40b250803d715c285eb6c306036a63ad4de81e9"
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