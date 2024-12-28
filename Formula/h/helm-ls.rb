class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.1.0.tar.gz"
  sha256 "6cbbe74114e6a4b8cd0821e372190f67743bb0528ea364a969524c754ba00c22"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b2c5d5cb4490cb05371e63bc74d127d597f50bdb359a6f1e2fd1468f5151a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d771e541a5c38fafbcd659018d8f5759b25b6d66a3de32a94f379766c27ebe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db311950e0c37fc990a9ea24e95d5a1f9dbe6f78790878bf0cf33a349336da79"
    sha256 cellar: :any_skip_relocation, sonoma:        "666e15a046477ac540c2e1c211e91ba5183f12c7b2a70d823faeba7c91c83592"
    sha256 cellar: :any_skip_relocation, ventura:       "d81557c7fefd57b65b604413bea2ce2648e160b720358b4e60c2cd27042443c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001b6074a8c532281fed3d992bb5dd4629e4ba64aea0e4a9e7672a3547ceae8b"
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