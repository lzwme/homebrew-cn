class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.4.0",
      revision: "12678aa0a687ce271f6797a11bf633687baf1ace"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef12e18cac0a5cf7cc28a9e96475a67bb0c7f8ed5b1a5ba093c64e9d4e59645"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef12e18cac0a5cf7cc28a9e96475a67bb0c7f8ed5b1a5ba093c64e9d4e59645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef12e18cac0a5cf7cc28a9e96475a67bb0c7f8ed5b1a5ba093c64e9d4e59645"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f0892dbbfd1b7e58800170b3fba8f5a6c3a45eb65398c31c9f5a781a76ed36c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247ceff50e1a28bdcb7c47152258310cf110a82eb4fd1ea739a71308691dd505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e102826e28364552a8bf4e9717365eb8ce45b132990e4ea0a6b81948ecd83320"
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