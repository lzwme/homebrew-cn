class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.18.tar.gz"
  sha256 "c0bf6286857e2d530d46e83ac25000b3a4b0aeb58d2e5e7feae3695558e176e5"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5c9d5c8f693883d8c76563f8c2b21cb318982db60f7650bf23e12ece20eb9b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c4a3b7f5f8bdebfd7e3f1eb1d15e1605c4507cf1d59c99977476372222944b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4a24eb440a6a899e5eede78b9f9ec90d1ee37fe623e2f6df3d44566704b592e"
    sha256 cellar: :any_skip_relocation, sonoma:         "42c69eba34a4f257bebdf7eef5150b6566b293934d03a23468a73a7b68e7e704"
    sha256 cellar: :any_skip_relocation, ventura:        "6808c9544fb9a948792e3609874c954325a8ef7b7baa3ea686dffe9e98ee2169"
    sha256 cellar: :any_skip_relocation, monterey:       "6fdee922ee4f69d640682d0ac5980a9e9bfeeb8787e4ee1307eb1ffe16c2e8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87db61c94a015af5edb11f3156f66c184b87ba421b76a0d836c8b4ef860d4cfd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.CompiledBy=#{tap.user}
      -X main.GitCommit=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"helm_ls")

    generate_completions_from_executable(bin"helm_ls", "completion")
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output(bin"helm_ls version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "workspaceFolders": [
            {
              "uri": "file:#{testpath}"
            }
          ],
          "capabilities": {}
        }
      }
    JSON

    File.write("Chart.yaml", "")

    Open3.popen3("#{bin}helm_ls", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end