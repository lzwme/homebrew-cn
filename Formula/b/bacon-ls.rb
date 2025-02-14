class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https:github.comcrisidevbacon-ls"
  url "https:github.comcrisidevbacon-lsarchiverefstags0.16.0.tar.gz"
  sha256 "db782e4c79f8aeeec9370bd10a986a991e0929055ce92baa0dd9a4847c171590"
  license "MIT"
  head "https:github.comcrisidevbacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4940f897ca1df93ae9f9e96b1e430c10747022d9058832b591632ee884873e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76bec4b7e2c68e524d1eb999e2ab9739b88564056444146979425dda18e8a2b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54cdb4ed83b36564d155ec092a8fe9c2ef5fe888d2946fb4ec0c64a0b77c98e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f98d8853bcc964491cb6f40bafe0a617684d2fb5ead9b95864276c5ae25f450"
    sha256 cellar: :any_skip_relocation, ventura:       "dfe548f5eb42ed54f9f7e3554c2fbbe4ec10e944cdab05e01b160c58090f2aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f25e1dacac50c72b5299d39f4b8c7bad145fc03cbdbdab04008ae090532a9e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(^Content-Length: \d+i, stdout.read)
    end
  end
end