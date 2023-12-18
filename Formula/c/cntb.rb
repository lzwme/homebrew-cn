class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https:github.comcontabocntb"
  url "https:github.comcontabocntbarchiverefstags1.4.7.tar.gz"
  sha256 "d36d4516146cc366818569cd451c9f19725ef60f7054d842ccf697fe16f47970"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59c8ac2af1214fff73b4c0bf8a47ad14d58f72f304f15da04a6c27f4bfb09c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ee4f491364ec52c342518fb8c4db42c860ee3e3cb4a20f5677601ee9255da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c8340597adf564bee40f50e76285504ce5da1fc7f206d56cf7eeabb8b2d047"
    sha256 cellar: :any_skip_relocation, sonoma:         "edda55e22c9d9c4ceaca155f171e935f745ef08406a2e61ab08b71ac4fd27da5"
    sha256 cellar: :any_skip_relocation, ventura:        "c0d102cf1ee32e9ab151aba9c9de660cc699e200846e1fdaf47e71d2809d249a"
    sha256 cellar: :any_skip_relocation, monterey:       "332731e1544794b0be3d2460869b171cd3d0c016bd1196467d2bc8397d91ef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44d3a2eb35ec4fd9b11f95dce9ff253c914654d44af96099c745ab4ec3a21e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.comclicntbcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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