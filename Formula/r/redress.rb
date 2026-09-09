class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.84.tar.gz"
  sha256 "ea1018fa5660776b11980348b9ff44403301c450f5a251c76ed8dd82d45b31f7"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5a06d10fa9573dc90b1feaa4e7a4c930d5a261506d57b6a7aaa401aec5a0c29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12681d7da988dc7a5f0f9788f6abd8fc48f8db202fb74b852dc67a3eedbc924d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b68859c41c959c63ac3ab6593668b5c31097df3d6034264695fa92481c8e7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d49f3a322918a12b6742eae92a95221f35f4052995ca319e0872b1f582a395"
    sha256 cellar: :any,                 x86_64_linux:  "9338d1495547118e3a723b75e83517ab1397b4d3d659eddf4dcbd2d059e3ff3f"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
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