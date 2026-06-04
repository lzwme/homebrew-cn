class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.69.tar.gz"
  sha256 "bc948f4997e86cba0b700f4157d8bbe33ccf50d7c8d03b61e8f7952c1b860cfa"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b87965b00e6105a995de05a55f748e0773fb44e512be813e378642c1bb0bb35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b0d86529145fc48aac443054de681dd7775ca544ab6e12512184e0758a2b6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc9be400349021575a61681c9d91c6deaf9c2d0b6bff014dbbcff426badd6d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a45b89006b0971d8c36bf218f3903d90bd05a12c301153a7e6c8b5ee087e5d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079fe8fa8500b07452ec599bd9d1dd2f55053c7f76348420da08e2f18e6738e5"
    sha256 cellar: :any,                 x86_64_linux:  "cc185d90a38d189f96a07772d0eba382641bc46b1ada85c8f898d7764413a888"
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