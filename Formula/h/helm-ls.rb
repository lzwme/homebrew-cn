class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.13.tar.gz"
  sha256 "a9fec2c82811b3aacc3547686b94933cbc479637a2f9997d01acf7850de06f0d"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65fb0bda271511351822951cb03a0fab98fdb45cb3601e7470c1857d95349300"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e5806893d3909edfa5e992b07a8551edf51b43cca13e05ee0c0bd02257f5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d39d9aa05d2badbb0ced6e29511b76e16af353e268d87c510b4fc5bacb83e60d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5069f4d95f8d01c743546048249f8aea81b526d06ccecef1fae14f65653ebfc8"
    sha256 cellar: :any_skip_relocation, ventura:        "0d900ece01e662f9c1bb625dd236009d91568f6fea721fcab7bdbca0af0fc122"
    sha256 cellar: :any_skip_relocation, monterey:       "2124bd845c0f60b98970b2e9492c978d4aeb75dccbb271b0c3ce021c6e14b548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595e9eb2f8207f027cf84af263b2ff9e9c3375b6391ed27d90c573af0b9d2a20"
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