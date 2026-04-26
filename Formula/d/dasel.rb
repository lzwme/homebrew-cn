class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "cfd84042c36cabfc1ffdefac35047934777cbb313a3c4ca5e0b717411f500124"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c91a08594cdfcb126c784188a912d4fbb605da83a2651df7eec7bd7483d3a6c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91a08594cdfcb126c784188a912d4fbb605da83a2651df7eec7bd7483d3a6c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91a08594cdfcb126c784188a912d4fbb605da83a2651df7eec7bd7483d3a6c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee44a4715d74c2468d5b6b6fdde8c7c0c6dc03d50a0624be414325e28d60914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02d860f19c00fb7f6ecb7a836eabe406b93e53c27aaaef1a177301fc8921dee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279a8675b9e70031eb19700f58596a16cc2a9a111973a416a5af77a2746c0844"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end