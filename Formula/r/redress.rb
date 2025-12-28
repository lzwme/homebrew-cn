class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.50.tar.gz"
  sha256 "5404489a639fc855ae46b9df343d2a80e81f596832290561eaceac8447d7f3f7"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b23c171a060bf6a24a1254fa6de967484b9b10bf8fb8f8a823f8a504315621a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0163977ef91d18978dd14298ebabbf50e6bb1eaacd04b6efd35d1870473fa79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef4c2b131afe804b8aaf3b7e4649baa5885fb0d3cf1f6827618d3236a595575"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4564e875151376aea61219e50c9598eb83cf4161b085565d290dc3158d8b657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "351102ba60df86aaef87eaf39609fcac3a2dc1660db1d34b310b478aec9897e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96121b17b39c9a2aec11648e8cc3a27e6ac4bb90fe405716326988d5e04ea58f"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end