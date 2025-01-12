class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.1.1.tar.gz"
  sha256 "f0db0f52c40d18dc18151f8df98c26afb7c1081b5fcf8d8e20c9094e1d3eb369"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f193b0a9573a888346589280d268c0d3a91fb339aeb9701a10ea60012dad53a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c153d4c0d22755c52f3086558c5672229779e1f0e32f060ab9979a16533d5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da2f51751ff951165f7cb6174c25d7da51af31e6613a035ca335d0a983142159"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c3f75c5e0af7bacb1c6bea9a6bfba4349c329d72f4110371d599821bf17360"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b8ce3e41b974f76cb8bb58ab4e80a5d143468ca1590c7b0d2aae8a144860d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ecf7838224ab3a5b71909e22ab4083a0aac846405b403ab8c8ec5d4e451e0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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