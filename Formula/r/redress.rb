class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.74.tar.gz"
  sha256 "7fe7a7ad7e0bd87c16f046a4dd0bcb9927e84b57911a8daba55caaff4ee0340c"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a592614e2df9f06b7f250b7ffd4355575d1f661603469abc3366c8d6737bcf37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8479987ea8ee601479f7ea87744eb967e98adca7bd3c5ff2340403e847b6c68d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46457b5a01dc4955dee80b1ba1d5d46e5b968536b0af3679ce1c4e0776f5252c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0540d6d7a10021d4d68274c7ea5454eb4feb6fa4c104f584476d447afdac54fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783dfb349d06f3d4da5c0d468b15e84bf34221db44c865a949a0c8a07129157a"
    sha256 cellar: :any,                 x86_64_linux:  "54dd47ec3c601e9c7dfec4ca151c51eb66c5113d8e7d75a7c454285ccb78469e"
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