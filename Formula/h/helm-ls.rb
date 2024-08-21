class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.21.tar.gz"
  sha256 "8faf4fb71c20e45f586f7991ae5ff7485a9cd7eed52219a1fdb62e857b83da40"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "325a2327f55e7e3c37e3768bbc41514d9d9aacc3ffe55c454362c25ed33c4f44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af0d7fc2639d17bae0f0227790ff53fdc523e3fae5c2d3b4dae994e1cdcf22e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c40da4a19fa82942376a465c8795013dc6c29a75249c8543644ae570b332f86"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ce13601c3f64948d628801e49e28624fb8edad405f9da8c780494c783f72cb7"
    sha256 cellar: :any_skip_relocation, ventura:        "c400ce035ade9c1697327c9c49176bd4e0882c15c0d08cd30e13162eb1d6755a"
    sha256 cellar: :any_skip_relocation, monterey:       "03262b43dcf6281fb7c7facde4d969fb8d9f12e6949f6a2e137c02f8670e0831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f453dc50dde11008565ca0ab1dc9e007477a677442e552428fc361fb3fa40157"
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