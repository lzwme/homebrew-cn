class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.73.tar.gz"
  sha256 "4c7abc954cf15ed752644fadee47d11ff7b68d913a4ccf6fc7fc6ff97954ad69"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1368255f2c6803e5ee6fd7e3d3eaa6a71eaea6a2b65e7966ceba8767b64fa0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5384a333fa1d0bd0317f0ff839dcce29208191a8b1f07602ccb74fbab061169d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154b82a98af5e109bbdb17eb57ebcd9ba3e9dc7dfadd492a0023da77a8a2a011"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d1a65a47bb4988cf1125668d512c24ffb170b26112e1a41e333e37f43c00b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3497e624991f69983d83ecc98cc5b895244aac5b9a691ebdc430022721953e"
    sha256 cellar: :any,                 x86_64_linux:  "0df83b14409a06459fe88cd12b46afe3371a24560d6d4cc3d0bf95a96ca53d37"
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