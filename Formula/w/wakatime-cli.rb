class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.81.0",
    revision: "2783050bd4c3a5845338655b3c1bfd363acd7fe0"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f35273857962cf3c5ca02f7bdd750a9f48a41dcf18a5c8de68f6ded52e80417"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e70e0fe0e01da6505b00683d552d58cd532ab59fee1704d3f5dc6a47476eb52b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff6f22d857e7562401f8a0648f1d1e8f42a435f93500c4753dd9551e97902a9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33b06f5f06284223efc303e79c810131112ced2640bfcf4bd549cb3a8e5e95f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7c9f7b433e7e3e0932236e806f1b885642fb3c9e5491746118313c9c6fbb97f"
    sha256 cellar: :any_skip_relocation, ventura:        "a27183c1616a6656d7793c653ee38a8d01fb041fc280eea2b8d9f8a9c8e1be01"
    sha256 cellar: :any_skip_relocation, monterey:       "1e5025d031c39344b9b36b13a498b390acf960c53b28ec606023e2ac3431c413"
    sha256 cellar: :any_skip_relocation, big_sur:        "798b70956acf553f774ce3440092085d5af5b42005afe0f7c9735ad120745e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f7311d4d3ac3c62b348525f81aab427915b7b0a09a086b8ab5e2720ce425fa"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end