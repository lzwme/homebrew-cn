class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.88.7",
    revision: "8a45c197f85f520acee531e8d85ef4b0edba439f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3c5b125ffb05ae8548c11959579dbfa65207a663a238078b0c03f39c68f5a3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7270bcae55e4baefd8f15732e6eaf22e45bee2ba554644e6574a4556cb46b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "594b78175ab208211ff4f6ae7c590ea87782d452452d23d561e9f2329783fa6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "83a2c7cdf995e77b7116a056cac2a7e786f2917ba97a31d1aca50739ccd53583"
    sha256 cellar: :any_skip_relocation, ventura:        "497ceca75ad3e959323c6a212748324f7ed259b2b1c284d9130e00771c2068ee"
    sha256 cellar: :any_skip_relocation, monterey:       "2e294703b85c44516035a0f05dee96cfcba9c7f1041608bb25f52f6566896d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083c0ea09824ecd24a68d73f46f0f0432ea9b86c0a2fab4ed427a233f8faa809"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end