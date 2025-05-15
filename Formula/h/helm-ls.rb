class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.2.2.tar.gz"
  sha256 "e3945bcaba746a77ea48358e96d738f7aeaf5fd1a8df3a9dc6ae2180e60d8293"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de07d6e4cce9a468bc17e5ff2eaa1760cfd4eaf660c217fae62d9297f761318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d39909350f51e14d18ac9d54831ca6a7bd975c92d46fed01a29cf192e88dd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffc943640cc4af33ae672a0ddea9812ebe967edd969061ff0dabc471fcce1a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1160df1fd8402f4109469cf19d7d7ac568fd4c9585d954df472f37530863f2c"
    sha256 cellar: :any_skip_relocation, ventura:       "ee71981f5938a9eea1b396a8d5e1088ea933afada9f154dc69432429b6d27d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66bce3b1a2691f963ddc72ebdf5e62e9c3f74d30a843e3a183ad3fc4b2e8d26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffba8dee3f42eb6c2e358390ec751016b9c9f3054005f4cd55df57d47e282c35"
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