class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.11.0.tar.gz"
  sha256 "58f4d2bf585fb53da9b8cde982afb2e11999620af44bde4fecc2c697e96f4a13"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6658536d87a0abad26d262629fc3129261768663e9f39bdad332df39e7ef4c2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6658536d87a0abad26d262629fc3129261768663e9f39bdad332df39e7ef4c2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6658536d87a0abad26d262629fc3129261768663e9f39bdad332df39e7ef4c2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2a4ac20785abc8b9e26ab4d268a8c8fed92aa9ab0b57b1b41394f48c1a4eb8c"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a4ac20785abc8b9e26ab4d268a8c8fed92aa9ab0b57b1b41394f48c1a4eb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a51162595e3894741129948c5145c8ad798568cf7f591e7b38d59e48505b8f84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.orggocmdcuecmd.version=v#{version}"), ".cmdcue"

    generate_completions_from_executable(bin"cue", "completion")
  end

  test do
    (testpath"ranges.yml").write <<~YAML
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    YAML

    (testpath"check.cue").write <<~CUE
      min?: *0 | number     0 if undefined
      max?: number & >min   must be strictly greater than min if defined.
    CUE

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          .check.cue:2:16
          .ranges.yml:5:6
    EOS

    assert_equal expected, shell_output(bin"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin"cue version")
  end
end