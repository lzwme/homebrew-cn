class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https:github.comcontabocntb"
  url "https:github.comcontabocntbarchiverefstagsv1.5.2.tar.gz"
  sha256 "d6823a3ecd8cb668e065eae97d7ca9c2a172826ba222789001e881e87592d733"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ebf61bb32b355cf6e37413e7d819324be9314daa27f7d7bcf28b12f0d8b405"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ebf61bb32b355cf6e37413e7d819324be9314daa27f7d7bcf28b12f0d8b405"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3ebf61bb32b355cf6e37413e7d819324be9314daa27f7d7bcf28b12f0d8b405"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fb502905bcd106e517f442e80f724a30d171938b0f185adb472a737759af75b"
    sha256 cellar: :any_skip_relocation, ventura:       "6fb502905bcd106e517f442e80f724a30d171938b0f185adb472a737759af75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1f7dd285d9f9c17f9195df6ebd77c9e338c4aa896adcb2ddeeb242bba419c0c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.comclicntbcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https:example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end