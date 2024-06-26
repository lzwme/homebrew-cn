class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.93.0",
    revision: "ffbeec27bebac4bf1d724073eb5515cf503cab28"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d875ce286065e24f41d9ac4cbc91d21a7bc55d74646cf4dee1f49792a15bddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acd5c2a75167e273987fcc2bdd620e04ef2c3db26974fa09280665e92cb797d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c80f4afb78c298c421aac51e8b8ef4d19b39b72405f1279797680960b6058e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6921809e195a40159624fcf1d450446284d9f1bc2451e94dcfbc5d188edb1513"
    sha256 cellar: :any_skip_relocation, ventura:        "ff2f8ad194cd4f61e48d5d225850e067eca7e8bdc1853dfc6f771d8978723740"
    sha256 cellar: :any_skip_relocation, monterey:       "6781f5553e6a52964b05c42341de81d79ac516dc51ae597089e1b371bfdbd283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636c5e7717e6c9e6d8509b528e649c87262bb63e72181cff7d81f7f6e3f8120c"
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