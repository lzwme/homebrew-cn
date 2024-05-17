class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.1.2.tar.gz"
  sha256 "10c9d8d1f5ac4cd43ae3a59c0a30880ab72d13b0778241668c34dce149813a54"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6be865a14615c463dbb2bbfadef6a9bf3d8d438988c1d86af9a534930f5236f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b77b6dccafd7431cb8d2471906b62d4ddda5171b8c8b78b8856b941f2db57b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cc0777123cf4a90943d0e609e44b0a48a1b9d9e4847d65222c8ee45f5c86658"
    sha256 cellar: :any_skip_relocation, sonoma:         "4af666470ffa4300ba3379d3bdaca821c9ee02c05b03d3c19a3ee8c6d6f80b16"
    sha256 cellar: :any_skip_relocation, ventura:        "026e55d04cf810a406852cb3dc9ac6540f4eff6c088e075d90d4e0d802097fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "823c0b56757a117d11bfb4dbf03e4cf168e27baef3884d741548ed329d2181db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d836da5ce1da5af2c3eae57cd98d1875465f427b32ca2f8560d0d271c6c4b44f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin"rr"), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end