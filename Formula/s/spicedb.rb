class Spicedb < Formula
  desc "Open Source, Google Zanzibar-inspired database"
  homepage "https://authzed.com/docs/spicedb/getting-started/discovering-spicedb"
  url "https://ghfast.top/https://github.com/authzed/spicedb/archive/refs/tags/v1.49.2.tar.gz"
  sha256 "375343717e81ace4108aed7442a6a0827a5b404f00d66a8527f37ca6e610c029"
  license "Apache-2.0"
  head "https://github.com/authzed/spicedb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b20e83a9057d45f64909c11f2ddbd17670e53a1c3306a2aebf9d24623192463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e403420bdaeca87fcc3b042af3f544f82baf8261b47d4e322068b28da556c697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0254f25654f8d641d2e1b6780a3f705810074cd7e1e1c60f23869641771af30f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3434be339a68d83257b1419bb72472e283e7459532f89ff5c296ddfd0916d4df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8db1f47f3a5276bd44ecb93fa046d963e53937257ed1f316340be63c3012aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566651576b6c2336d79828131fc2acf8bbefab8e0c96f93a81abe27c046c205e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jzelinskie/cobrautil/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spicedb"

    generate_completions_from_executable(bin/"spicedb", shell_parameter_format: :cobra)
    (man1/"spicedb.1").write Utils.safe_popen_read(bin/"spicedb", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spicedb version")

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

    Open3.popen3(bin/"spicedb", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end