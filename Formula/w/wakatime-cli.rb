class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v1.123.0",
      revision: "2b29d7b04aafae117179f135af7e61ad17683355"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "195c7c6836342cc919609c002af0672b3db888eb4b5a48769772a41f037ec695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195c7c6836342cc919609c002af0672b3db888eb4b5a48769772a41f037ec695"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "195c7c6836342cc919609c002af0672b3db888eb4b5a48769772a41f037ec695"
    sha256 cellar: :any_skip_relocation, sonoma:        "13417a51fde26644f9e1a688d089ce76d7b4c2c39381c4edab48141b11699349"
    sha256 cellar: :any_skip_relocation, ventura:       "13417a51fde26644f9e1a688d089ce76d7b4c2c39381c4edab48141b11699349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db91dff07d3dd45beaddcc99594049611bbe438220641905eedec8210e008447"
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