class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.71.tar.gz"
  sha256 "19e035129daee5008ab375008b5c7bd33314814892d22978da77be3435027e9b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe6ea9824ac8844b076e488f9266eff998d3f5822ad30826d5dace0f6c9feca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dfdcb7e18b0873dfdcd8f685773e7e2225e8ea9f9dedb585e5186e69b0c5f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20d6c85ba2dbc097e1dd4c7367e6bcd716f687e6e6dde76b83b88fa1845f34a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a146161996d2be8a842dbc987bdf94ae983c913cb1855b4430612df4ece1ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c6eebddd52f195d016c775d25d03983c6545fe5b0c9727c8d0522394a35714"
    sha256 cellar: :any,                 x86_64_linux:  "01fdb270242b120b781ba7a14906f98e5ce34c862a952d3ac005a447e7b09598"
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