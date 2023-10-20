class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://ghproxy.com/https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "f8d2ed860b6dcb13b25fffa2d24482bf8162a84cd22a7039b589585b3ed952a5"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db52566dc2db00e3acc467f6d16421e17bc572b481ee468dd1ebd5372c50f4bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2e09869011dd801a87c71b2259939214dee7440a4e79d7542e4e3a958a1d59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00e15606015694396158d56a19b8741cbb73fa90e39b963ee8cf132508ad2407"
    sha256 cellar: :any_skip_relocation, sonoma:         "00c955000ceddff1606f5ae6ade544f20d50e6d5d1527636630656c594c00eff"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6a9143c6be2579458a14223fd404ba9c65b1a425ed351e23779dbb4f14a557"
    sha256 cellar: :any_skip_relocation, monterey:       "c6e3fe0139668548866564f66eef25ae6ee1800a1462ec3be0cb1d8d3e2a16f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fff74667007dbec41a489b40a339aca830160a2f6b5a0cd727f4e6e873aa3ac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1", 1)
    assert_match "[NextTrace API] preferred API IP", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end