class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.1.0.tar.gz"
  sha256 "6cbbe74114e6a4b8cd0821e372190f67743bb0528ea364a969524c754ba00c22"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874a97cf9543d19f8ba4687f0e9f809a5d2f742b036cf5529b90bb9a79eb7577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da6658cf4a6ce7f1a92d39c973347caee051d78826c39fe1e4d0b3a97ec1e87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7e8d7110fd8d3e90a6d4aa1eaff674a63995a90cbed88701da27c0a7214bc5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d793bed14eaca1e833610ffe73779747b23adb6bade8c5d38e5d5419b6cab48"
    sha256 cellar: :any_skip_relocation, ventura:       "bf81a819185bc3e3bf4d512dbe2a1f79deab59015da9e8f3e915edebf9ac2f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410ffbbd5cba045de940112775ba77cf0f14da911a58b6abeefe7ade59682a94"
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

    generate_completions_from_executable(bin"helm_ls", "completion", base_name: "helm_ls")
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