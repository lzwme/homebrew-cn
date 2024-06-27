class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.9.2.tar.gz"
  sha256 "949084a037dce6af09072d5b3acd9e6e004b49b2b24e1e3bf93e71bcd1ca99e0"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b8e79538b896fc66fd48e3fb5084c2edf2e581cd26496ca3bd0e04a45c3794b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53cb070a102d763294af2da09326b7c83cfd16d2eb18e7174145d504ecb2c55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "002a0d7a28bb1d5430ace1d523f044f2965556c59152a10d4b293dd61040eee6"
    sha256 cellar: :any_skip_relocation, sonoma:         "252b2fcd53af336e2c2954467376b8a70f4cdeeb6e3b5313995f94c31fb44953"
    sha256 cellar: :any_skip_relocation, ventura:        "16accb69f7669d2b37e00ea86590721f358300766095a89fe1c9070efb4bcd59"
    sha256 cellar: :any_skip_relocation, monterey:       "693e5308880f425c89913a075d333f345cda8627ed8bb76d781070e7c1f811ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c6b19b94e5eb2fbb5763c32654e5fde51c9296bc48671a647f1184cf202a7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.orggocmdcuecmd.version=v#{version}"), ".cmdcue"

    generate_completions_from_executable(bin"cue", "completion")
  end

  test do
    (testpath"ranges.yml").write <<~EOS
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    EOS

    (testpath"check.cue").write <<~EOS
      min?: *0 | number     0 if undefined
      max?: number & >min   must be strictly greater than min if defined.
    EOS

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          .check.cue:2:16
          .ranges.yml:5:6
    EOS

    assert_equal expected, shell_output(bin"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin"cue version")
  end
end