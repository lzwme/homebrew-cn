class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://ghfast.top/https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e93ac9a2a8576697d327e3bea3005b755111a62986977d66140b9e5df5af6be2"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2216f8baef44fbe47d0f4ef4560581ee1c79dfeedbc25fe31b855084bb45f70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eaac9fbb54a49c282aa6527ac16798c44b78e060d333400df2e682a83d5b27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7179f4d3d65cb02fe7f691eb242170e0c53e45c65e410d36344efd728f2ff88"
    sha256 cellar: :any_skip_relocation, sonoma:        "b45c42c75be50c4409faa8fa68fde3ed9df10c91ac7a5d511a87a658f936a45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f650d12eba0f434fb2fed80e51e299fac8b85a46aa5a8cf8824bb70625b7fd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd38f52de2630682f21d8298836f53365f3354475b0e9a079738eaf89cae4ad0"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"
    system "just", "install", "--prefix=#{prefix}"
  end

  test do
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end