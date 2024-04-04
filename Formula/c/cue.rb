class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https:cuelang.org"
  url "https:github.comcue-langcuearchiverefstagsv0.8.1.tar.gz"
  sha256 "353277b82998482141f727effba8900fa4ccee81e20bfbe50a27563f6dee57ec"
  license "Apache-2.0"
  head "https:github.comcue-langcue.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73ad28b75242e7cc9ce96144ec67622e3a7f93e71124573108bad9a92a91981b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0995653e745fe2546e141888720dde0a47dfa35ba38411702d40ab6b37b36807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9ce338249f0cb6f362a40b34ce96268c9d985fafcf98a9761555abb33ed2e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "79c041934aea60ec22df011e731bfcc1d9c165b7aaca299b74f408dabda602ec"
    sha256 cellar: :any_skip_relocation, ventura:        "db0ec8dd546e14fab0318cdb1db16f96e81a5a30ce47fba3081a84d6250928fc"
    sha256 cellar: :any_skip_relocation, monterey:       "aae349febbd2f80f5a5412de1408978be75ae67cedd19f70874c2c45b9eee208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa21e54d3cdc4e50570f9ea616840b48e76c4197bc179a02b3ce0b699dcb0e55"
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