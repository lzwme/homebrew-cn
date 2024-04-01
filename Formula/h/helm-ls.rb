class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.14.tar.gz"
  sha256 "8df2cd5eeaf21e046bcab843d8fc280d355c65627ca1d084486b986a2114fa94"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9d5acf4a5ea7015f566605e03b0d51c51e070d13daba7b11eed2b7556eefbe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7e21169fb2e5a639385b79c81caf9f6367523d1678a58b24f3aedca859640d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e116491e2b4c68a515c16acfca02fedff7ab014d46a6fa5371e808efcc49724"
    sha256 cellar: :any_skip_relocation, sonoma:         "d451b2d7c9ddd36a924cdd4facbaa189f52849e61d4d28b38f98d05bd52d4f8b"
    sha256 cellar: :any_skip_relocation, ventura:        "16361b875978ef83cb5685dc6876d2494a92e9bddebfd1458ba073b8cff92a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca553a65e253bcc421735581bb7ea44c85376caab5788b38fb2eb365167df426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e762735efa6787ec1b856eca68b08097f29d15407f08f9382612d45a4b48e428"
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