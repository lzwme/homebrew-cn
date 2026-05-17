class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.14.1",
      revision: "7df6000673de4c00e86f9698b0593e0081a17795"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4696cb4aeba05fcc6c149d22a4307c72a8e9d245b7cf5af28eaf6ab2fa53786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4696cb4aeba05fcc6c149d22a4307c72a8e9d245b7cf5af28eaf6ab2fa53786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4696cb4aeba05fcc6c149d22a4307c72a8e9d245b7cf5af28eaf6ab2fa53786"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb15651f24681b6416215ed3b08c7729ebc1b63785aab696dcb6e2777aa8a717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4dc2a46d649f3416ee56a771d31bad47a614650b746e66ce6ddbd5fd887998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4008d398232fc3a53ed189e3d7210dea9a69ab929e1a123885f85627315d0c"
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