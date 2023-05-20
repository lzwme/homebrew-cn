class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://ghproxy.com/https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.228.tar.gz"
  sha256 "b9c51e8d2d43b76f0599da9c37562b9393df67ac26bedacfc046258c00800a3c"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab70def48c0906aacf433a9d971dd458f2be53d43ea1c80693aa906a7948a54a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d92060d735c8e3548ab56a73ff95067639ce767a56c0c85e60fa33cbf614d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21575941f4fa9b67699361f742030064ace198464be0337d31b300dab203976c"
    sha256 cellar: :any_skip_relocation, ventura:        "382554d5e8c963a8535833b2be9edca670d1ef082a7785a8c55c00e9fed425fd"
    sha256 cellar: :any_skip_relocation, monterey:       "789624321378b2bf50cfc07377c90f7e0ff849f80a0f5e4de9dfea7465ab5909"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d43c2eeefe2f9f2b8cfc243de657d4b9dc971956866a578cdc42c10f79ba88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9273f714821328689c4e116f262f674556bb277f03bf0b810a9a2bd4eececeb1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end