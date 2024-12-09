class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.27.7.tar.gz"
  sha256 "792b161d727d2613034edbb2c59008ef6998cb7fd7d5a998a8658bb2536dc80e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f1333072eee34a5d09fe1d4548be7d98f7a265d0b2654d063ce6f7345ede61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f1333072eee34a5d09fe1d4548be7d98f7a265d0b2654d063ce6f7345ede61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f1333072eee34a5d09fe1d4548be7d98f7a265d0b2654d063ce6f7345ede61"
    sha256 cellar: :any_skip_relocation, sonoma:        "21a799aeb24924cb874c7db57d1f83603e619e27a81109e1150e9ba6006478cc"
    sha256 cellar: :any_skip_relocation, ventura:       "21a799aeb24924cb874c7db57d1f83603e619e27a81109e1150e9ba6006478cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9748e9c42d1b832574f34636ece2b9b60e47631f663fa1fa41c3611423be64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comweaviateweaviateusecasesbuild.Version=#{version}
      -X github.comweaviateweaviateusecasesbuild.BuildUser=#{tap.user}
      -X github.comweaviateweaviateusecasesbuild.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdweaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}v1meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end