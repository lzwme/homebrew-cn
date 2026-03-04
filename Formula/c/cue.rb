class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://ghfast.top/https://github.com/cue-lang/cue/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "c1899ac0fb7e9f95547ce5b94fdb05791a79120abccd8eb81225ea0ac389bb43"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759eb2e15d8a244f4061afa0aa503251a9bc72033b04d61f6842efd5d4d09cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "759eb2e15d8a244f4061afa0aa503251a9bc72033b04d61f6842efd5d4d09cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "759eb2e15d8a244f4061afa0aa503251a9bc72033b04d61f6842efd5d4d09cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "af68de0367670b3300b1295f33c5fe205259d65a1876ea5a90461a2d7593320f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccde5fa83f7c8221d6936cbccc103013d701e169a1091ad460886b44fbc6e352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6fd69b721c4daa6ee988421c89aad954b15cffd9e6ac6a1c2a63556d943791"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", shell_parameter_format: :cobra)
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