class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://ghfast.top/https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "af3857f333b85da0133074047ee9cc121e43f172aec5116a3659ecb790f0af47"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c422fe5baf355d0706ec930a2439423547398a27d939aed283cc4f02fe58dd4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c422fe5baf355d0706ec930a2439423547398a27d939aed283cc4f02fe58dd4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c422fe5baf355d0706ec930a2439423547398a27d939aed283cc4f02fe58dd4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8db61cd3743e8938e6a44d1cf70ae9f0041c2f1170c46bff497a425b512959a2"
    sha256 cellar: :any,                 x86_64_linux:      "a5139cb55ecbe568222640554f21e817467f16f5d03a7917641a7298c23acf11"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end