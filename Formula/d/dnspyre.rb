class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://ghfast.top/https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "0f6e362018082600ac43e2b87cb0162c5f5957be601016c7a6b945b245f7cfd7"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d06282af94eab436ce28493f5064976ffd9ad57aa14d85823174aadff05e7701"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125bf1a59d35165bc2f7cd993c4370c654d12f6190e91c351e39d1f99c8dd5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866fa6f1623d3272b9c84db7cf18e38016577977699f73f276451db28bca8dc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b371ef9a81d361a51fd8eb8e81ce5fa40ece17ef8766b259b57df1c36d4f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9093d14a272b31a088add54569793caaf339b63fefbd913d28ee817f902c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34312ace135ad9e65cab60973d3edf1c8a13497069af000675356fdf94017793"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end