class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.21.0",
      revision: "22b3916ad1d4753362cc08e76a1d631b388a5602"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f73693afe4dc394343a5dda387c767ce3657808c94b4f9156ae81fbdbd057b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f73693afe4dc394343a5dda387c767ce3657808c94b4f9156ae81fbdbd057b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f73693afe4dc394343a5dda387c767ce3657808c94b4f9156ae81fbdbd057b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "40c1396419d8bd67398e62a48bb37a92f86569a99c4725de93ae37298175aa9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd86f0cedc2c0b7bf99d1bf67d2422e5a3d48e436fcc86b9ba91cf8f48d71f05"
    sha256 cellar: :any,                 x86_64_linux:  "6fd4d010ae0217f9f35a7e2fe0a76ec8ffb4e0e66fd0b812a2757e31486c860d"
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
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end