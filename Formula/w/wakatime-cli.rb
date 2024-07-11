class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.94.1",
    revision: "6f350218327cca564d67acdf3ed6cc8cc49ba3f1"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "401532fe3c3e00dc4cd15a285bae737ffd27c84de1ad2b538637ad980f562198"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c7ba39e93382e31b2edc2cd2fe856891946659a6becd5dafeb9458dbb1526c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12357c519997335f0eaafe1f32019e1c69ee782f64833c316deba7f6faa0bc9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "349498fac12262a2e0d5f6311abecf05d7f1f8170cf21dda4543ac03a903d225"
    sha256 cellar: :any_skip_relocation, ventura:        "811b7a12d1beaa12a7d4a6b97cd422991d8a64a4ee1ceb544b9f3ebdcc1b2927"
    sha256 cellar: :any_skip_relocation, monterey:       "1afaf3f87408bb417fe7cfe01520ec423e3da0262b5a4eddf1f758605f8322a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0746f52327d5fc09a1e7e1df9171c82f4e92dfab9786265011c3db4f41e6c1"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.comwakatimewakatime-clipkgversion.Arch=#{arch}
      -X github.comwakatimewakatime-clipkgversion.BuildDate=#{time.iso8601}
      -X github.comwakatimewakatime-clipkgversion.Commit=#{Utils.git_head(length: 7)}
      -X github.comwakatimewakatime-clipkgversion.OS=#{OS.kernel_name.downcase}
      -X github.comwakatimewakatime-clipkgversion.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end