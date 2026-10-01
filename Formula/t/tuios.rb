class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.gaurav.zip/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "b0499eacffd6db8fc1ca62c6e408ec1a0c23dbb62612b94a4f7b574b4ee7eeda"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0570dfb34536f182db200925edadf06c0a8aef986d4f4a9fc5518261395668ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d123cca4d1f6019631009fa9241d60a7bbe05d478a9a7f344f64be717907828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0feb03ff79bdc7dd8392b999e34349a52d4ca6c098dfcb934fe5dbd506652375"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de788fb1781dcf92f13f08794973928f91522f5031d5e54c1e42bd71f422ab11"
    sha256 cellar: :any,                 x86_64_linux:      "a624a2b22b3040258636933f62efccae1e455c6566c6e19d6e4ae81582b1f513"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end