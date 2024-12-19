class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.28.1.tar.gz"
  sha256 "85839cee892cb50cee933f0a25fd518a85ecd04d6159322c8a63445333ff6355"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac286ca5d2c94a7cc748745fe8c733876be050acee8f58f84b7d73e2c68f5151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac286ca5d2c94a7cc748745fe8c733876be050acee8f58f84b7d73e2c68f5151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac286ca5d2c94a7cc748745fe8c733876be050acee8f58f84b7d73e2c68f5151"
    sha256 cellar: :any_skip_relocation, sonoma:        "45bf3918e11c44379385590b33a8b23b7cf47a9c60bd94712b723bc2998c0762"
    sha256 cellar: :any_skip_relocation, ventura:       "45bf3918e11c44379385590b33a8b23b7cf47a9c60bd94712b723bc2998c0762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df02b47a90e01f0b75bf69766e1a4db0f1665f0fd1b6e4232c8ae715b01a9b6c"
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