class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://ghfast.top/https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.25.tar.gz"
  sha256 "9750a2be8ccde95b750ee95124f4c77a075f5897634910aaed1259e9a6b9ed0e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0a08a9281da9241ffad2b0e073d420b423912288bf4dfab492ca7fa88f45ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d666978996041ce7745f121355a93451bdda9873abdde99b97555ec8db58a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552c685fd940333448bac0b9b295c4ec3015020be50c47564165ad792c86794f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4acf56af74da3b7cc3b83d1e00f53f6d1a27ab7af06e30712f2a05ccd791c085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf007697ad81784cea367a338fab79e3d4fe39ad2132beebbe00cdcf1d6272a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d06ff0d081ee5f5f43578bc83e35668cfc2b84ac46956c6b9b0cdf5ef0b5972"
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