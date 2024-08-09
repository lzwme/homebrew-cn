class Openfga < Formula
  desc "High performance and flexible authorizationpermission engine"
  homepage "https:openfga.dev"
  url "https:github.comopenfgaopenfgaarchiverefstagsv1.5.8.tar.gz"
  sha256 "30b6a6b8cd826f7699ab8d92376a093db66eaf6584d70b5ffb38e3aa0151eac5"
  license "Apache-2.0"
  head "https:github.comopenfgaopenfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cc5d87e05fcc9a825d7598fad1e9279e0412d87a5d86873599477e8aa005230"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94d810a643889b775ee73d07f8e195115623b59e33ccf25ba89ce97bd38f789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d3e8efb8a4f42ae02525d697442fe35b66c4b22c1bf91a13f7b46dcc4595b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "42e2d6108ad7d2048209b9ad934e9213de4feed0c1fd6c308c0547ce833673c7"
    sha256 cellar: :any_skip_relocation, ventura:        "2789067cf6671ac2f27c6f48363ccacf72dc8963dfdb8dc26990f5ec60d69f20"
    sha256 cellar: :any_skip_relocation, monterey:       "a7398283133e5ddbea8b439350ac7f97370f907e655580645084a9fe9b994d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948f42fc222220b3d453ca2ca225d8e160f7a16c27bf0b5c83a3dc9cbb1f1fb1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenfgaopenfgainternalbuild.Version=#{version}
      -X github.comopenfgaopenfgainternalbuild.Commit=brew
      -X github.comopenfgaopenfgainternalbuild.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdopenfga"

    generate_completions_from_executable(bin"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http:localhost:#{port}playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end