class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.55.tar.gz"
  sha256 "015b8becf83334cd8ceedf6475515ed6afaa1920ef954fa3f1215d956ba30da4"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86624ba55535182b4a1980472b5c8b11acc891089c837e93976cf0efa97306f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f01cdf00cd96746a8d57610bfd0ebf7e4faa742944d0a5e995f7f318372a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3f22f1fe7e6bffb4325c2f84593e376f4764cce18d0ea5c64222663c04eff5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d38baa6a7bb60dbbb0dc50e6498bb2678bffda6b92895b3da5bbb7e06219d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a975543f81428a77cec3d344b57acaf04ae32543c9acfee58afe1bb0d8e35025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0702cdef19f1e60a5e670e22d59b03a37a6a5ca02da6b5d611cda122c80f9a"
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