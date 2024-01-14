class HelmLs < Formula
  desc "Language server for Helm"
  homepage "https:github.commrjoshhelm-ls"
  url "https:github.commrjoshhelm-lsarchiverefstagsv0.0.9.tar.gz"
  sha256 "cef59537d2335c9821a2d60628bcf40451a137b9f5b38b3991d1914c3f4ec191"
  license "MIT"
  head "https:github.commrjoshhelm-ls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad208396cb3b4279b2b2bd5b17f40cf45b4b948d64890a62e244cf6cddef51ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465919ec906b493c8e8359142c2bd807d76e35c08b69530f234fddb1983d2981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af64d0c0abdcbf04b8277a21a87736e1efe7557a516fc7cdc412f4df97c9a849"
    sha256 cellar: :any_skip_relocation, sonoma:         "482da594366ac12cb6e001e3d24bcb3463e87fb34f361fd104488de8e845da95"
    sha256 cellar: :any_skip_relocation, ventura:        "88d29e9836875fa13cfd387b06c0c2f1f9792f919e4291b7520203027b3f781d"
    sha256 cellar: :any_skip_relocation, monterey:       "4015adbc81b0b19956d536a328392599e851b48f80db18ce0dd5749b421d0dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20bb977d185d4c12f2fd3feecc47f3119929ec918da29fe7bfac7b8867793080"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.CompiledBy=#{tap.user}
      -X main.GitCommit=#{tap.user}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin"helm_ls")

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