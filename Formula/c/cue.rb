class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.10.1.tar.gz"
  sha256 "e6587287de35ea5d1d0cc0f9952f8b1491324114b5e4233b78750c1ab786461b"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5366c09fc11877565d8c07e8174e73443ee0031df62722a74ab15d524ec3c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5366c09fc11877565d8c07e8174e73443ee0031df62722a74ab15d524ec3c8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5366c09fc11877565d8c07e8174e73443ee0031df62722a74ab15d524ec3c8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f324a306703e26e9f9b61206a659162bae7edfa952bbf2ac374f8627e2848a9"
    sha256 cellar: :any_skip_relocation, ventura:       "1f324a306703e26e9f9b61206a659162bae7edfa952bbf2ac374f8627e2848a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f30d4fc6114d2f90af6d8c7a62fa7ba2175b9c339c6a9eb6d8d85e5c7c2541"
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