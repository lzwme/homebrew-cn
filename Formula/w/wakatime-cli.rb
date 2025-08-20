class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.130.4",
      revision: "885c06c37719317404a056d6bcb9c8c54278abaa"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f71cf02b6f00f085b35dedc4c3f128f2b0f8a614418e92ca8bbea37eb13ae5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f71cf02b6f00f085b35dedc4c3f128f2b0f8a614418e92ca8bbea37eb13ae5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f71cf02b6f00f085b35dedc4c3f128f2b0f8a614418e92ca8bbea37eb13ae5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c60099cf634ee57e6fcd58d308b286d6c8da765ab823c613dc24e80fe5804bd8"
    sha256 cellar: :any_skip_relocation, ventura:       "c60099cf634ee57e6fcd58d308b286d6c8da765ab823c613dc24e80fe5804bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bde6c4299a61d2d8030ecdaff5a90cb90f7bc15ffef4769a53a2ba5c7276a29"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end