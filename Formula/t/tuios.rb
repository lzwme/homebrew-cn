class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.gaurav.zip/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "78e52ec7e544d4f31195392e486abc13f8de9b1045abea2d5f0d985e4a356199"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7671fc07a2819377fbe638b4f3f21d1e33c54696dcee285d02d90255c934e75f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abe81084877b936baee78a30597e40ecdbc3b4b71ad7f51ec55fe4cc0ac04a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0634a08f632c07bd7fc80348d6e065fc4dd9b4b37ecb2fb369018100b25d9528"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb5dafe4e9c9d43ae993623b7bb3e252e6c90be761012c675249f0654dd9aedb"
    sha256 cellar: :any,                 x86_64_linux:      "fe2b6c498d80a38a9286282f8f31cee286472af832ac3e2ca606375dfac07ffd"
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