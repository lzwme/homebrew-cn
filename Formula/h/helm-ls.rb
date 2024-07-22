class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.19.tar.gz"
  sha256 "cb8cf5dc748db1b6399c07f39b06181983e542d4d607f03f0f7c2cb2780bf9a5"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "befccb91fa43cee55f4b7096a338d0014dd25131a2b02913958903327f1bcd3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec4818d08266fd14a3e2d0b84033fcc262af746e30be0c7ef906aa9d102d7aff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f95467c9bbf07b0f66fc2c54af8c8e56873e1ef1a5a2eb8d61445d53612f1da"
    sha256 cellar: :any_skip_relocation, sonoma:         "afa1b5ed363ae9d305fca6023a75501ee3afb6d7cd36bd573cfd72eb28b1ea34"
    sha256 cellar: :any_skip_relocation, ventura:        "c07449293c5647cd32f4ca74229197b0fc19d304c0846496ff6fa5a867ea2d30"
    sha256 cellar: :any_skip_relocation, monterey:       "76c2c0544a01296f12b2f711eb21114a589489532d5611146c918bee5c9870c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab24549d51bf72d3482cc9efbcef0137acc16a7e971a6e1a60ca460854606b3"
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