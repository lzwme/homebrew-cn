class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.7.0.tar.gz"
  sha256 "964556e96459f6d0f1cce1a6548338bfcb9c88051af71a1c07263aba75c26b85"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d1a942107ab81f71c448ad178f835004328422d347f735b9b1e15098b58f4be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efdd19071a16bc611c183cc096bcbf7cce2ee7eff6e7dfe757de6c8cbf71db6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df5994063d6cd33e7e49bb605761dcb3034b7f9e1779796fcefdecdd5d21f22e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c23b8fc170ac78cb2dc510a6f41b05c248acfb9e611359aad0263558e82cb4d1"
    sha256 cellar: :any_skip_relocation, ventura:        "93d1ac429ae41a44a1c3fd676065013cac9035f41c282d48c2b5cc1aa4af4d13"
    sha256 cellar: :any_skip_relocation, monterey:       "4b5e802c2e07a083698c1e1978f104dd76fd98ad3572ecd6806d66297657e6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d86497e99d494a4b19639961e7b3d84786c3ecd195324e0f32a521a354e9496"
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