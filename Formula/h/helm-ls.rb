class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.22.tar.gz"
  sha256 "8602139460f387eb2b423d15f1ade0eba67835dec6cdb73c9d9a13964e44a671"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82489a21e0406d0b3b78e4aa74e572f301ad2f3a029aeb570bc311db32507a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c15fca9ad6b9016881229e9417cb5021ceac8a3e3b48dd682eb48bc8b7632042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e372050180846689858647e7c6c5cd28848464e7dbdac3ea4244fc3573fdf0a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3afa16caf3854b0bdb256c21ce61f87c624346199515b1d7b8cbaa94afe38579"
    sha256 cellar: :any_skip_relocation, ventura:        "9a94a4703202a28ef764fb7a1c14c2fb520198a1b5c353fcbbbd2bf3bc3bc8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "e00c79491e229059fbcc2c3ad783276e3bfb53f379ae930d3dfd1486410f67c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a74c1c1bd972c214742f1db161ac76528bdfc320a7b5b8262798437065167e"
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