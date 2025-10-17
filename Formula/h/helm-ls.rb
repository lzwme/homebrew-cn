class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https://github.com/mrjosh/helm-ls"
  url "https://ghfast.top/https://github.com/mrjosh/helm-ls/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "c3884704cbe556b7092929111a9791e290afe75fc3f6ecee7ff21f7794f85101"
  license "MIT"
  head "https://github.com/mrjosh/helm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abec07cb0e36b1fd6f4de583e7459d65368aaa7802750f4d0aeec0874382492f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9d9b650486c7392ec69da65741fe137e936ac3049a3edd6796e185766f754e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "966b3146f57fd717e82dfa3b638f3e4696511074631bf7c8191ec87c82448b98"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e93ade6b872412063bf6a7460b9b66f5e91b11767fdfce7d04d355ace41bb2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca49d2720d2b007a8079687498f6e29f051738188a0db0e31ff0252156dd06ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef97f8a048b57da16a38bec125a6919a4705fcc80d652b20b07fc3308111cf9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CompiledBy=#{tap.user}
      -X main.GitCommit=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"helm_ls")

    generate_completions_from_executable(bin/"helm_ls", "completion")
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/helm_ls version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "workspaceFolders": [
            {
              "uri": "file://#{testpath}"
            }
          ],
          "capabilities": {}
        }
      }
    JSON

    File.write("Chart.yaml", "")

    Open3.popen3("#{bin}/helm_ls", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end