class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://ghfast.top/https://github.com/cue-lang/cue/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "5fd6d74246a24e6c153510d1b0b2e1bf8482a6b108da879ce76da10986412839"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6982ede8e736c8bd0d6229b38129df22d84b6f464ad02b13162669be6f52ee31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6982ede8e736c8bd0d6229b38129df22d84b6f464ad02b13162669be6f52ee31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6982ede8e736c8bd0d6229b38129df22d84b6f464ad02b13162669be6f52ee31"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7d2aba8e28634ea20d464f9f945cc0fb0f1f630eaa3b44e897c6012c912d22b"
    sha256 cellar: :any_skip_relocation, ventura:       "d7d2aba8e28634ea20d464f9f945cc0fb0f1f630eaa3b44e897c6012c912d22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3bb8cee60743d3155e8e8acff845e2cfce7a235b7ac1bfa6096f91840dc08f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", "completion")
  end

  test do
    (testpath/"ranges.yml").write <<~YAML
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    YAML

    (testpath/"check.cue").write <<~CUE
      min?: *0 | number    // 0 if undefined
      max?: number & >min  // must be strictly greater than min if defined.
    CUE

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          ./check.cue:2:16
          ./ranges.yml:5:6
    EOS

    assert_equal expected, shell_output("#{bin}/cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/cue version")
  end
end