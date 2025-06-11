class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.13.1.tar.gz"
  sha256 "531dd591a164a351a2e7f2ecb38170ec129de2e7033d34d46887b34c70643942"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "013fb591722c7861abcdfaf4de06031876f581cd1259495b7155abddf7bbb44e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013fb591722c7861abcdfaf4de06031876f581cd1259495b7155abddf7bbb44e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "013fb591722c7861abcdfaf4de06031876f581cd1259495b7155abddf7bbb44e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a365c109fc0140f8df79e1a52bd28da303355f2d9413b24f8109e06138de86"
    sha256 cellar: :any_skip_relocation, ventura:       "f6a365c109fc0140f8df79e1a52bd28da303355f2d9413b24f8109e06138de86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfde5c0d2f8b69f843dcb8d0e814be62d32439060fc09ff85742f8ddea98c32"
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