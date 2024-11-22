class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https:wakatime.com"
  url "https:github.comwakatimewakatime-cli.git",
    tag:      "v1.105.2",
    revision: "ea9d66fb18129ec8f56fea291cdf858d74cb406d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7150694646ba066aa1b7c588e176149e4d496ab704956b2f91d992507ce43d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7150694646ba066aa1b7c588e176149e4d496ab704956b2f91d992507ce43d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7150694646ba066aa1b7c588e176149e4d496ab704956b2f91d992507ce43d05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a81d8d4ba12eef40d12fe10b524ce198f71c7a14deb5d7ec982964d34454446"
    sha256 cellar: :any_skip_relocation, ventura:       "6a81d8d4ba12eef40d12fe10b524ce198f71c7a14deb5d7ec982964d34454446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdbc8ba9581a5f291418b1f5091ffda73a3daf3fb9e991d4ef355e31bb4bea45"
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