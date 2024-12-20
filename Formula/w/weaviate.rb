class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.28.2.tar.gz"
  sha256 "2a84cc0cdb235b57b7aafb13863961ebc857dfdf1753e1333c3e523f4a49bfba"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa1540401f9ae22369851e04ce98b62a2d59b1cbca0ad5df0eb7ae2d1546a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa1540401f9ae22369851e04ce98b62a2d59b1cbca0ad5df0eb7ae2d1546a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0aa1540401f9ae22369851e04ce98b62a2d59b1cbca0ad5df0eb7ae2d1546a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb2e2828286dcc1d951d666181377ba90541420ab4e7b3bf73450ff4e4ed6712"
    sha256 cellar: :any_skip_relocation, ventura:       "cb2e2828286dcc1d951d666181377ba90541420ab4e7b3bf73450ff4e4ed6712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e684ef420e9c6d311c4c65ffa567f81d5298759444aa4cbe9a0d88d9bc8a3201"
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