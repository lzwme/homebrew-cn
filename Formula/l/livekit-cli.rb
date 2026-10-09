class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "9e4c82e20c47d2e2841127bdc4e8e1b67f46d9727f3ba31b59f773893922e4d0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6645864e54773c096f9be61c04fe1bf7b28cea5774a737c7ab8150202d1d6888"
    sha256 cellar: :any, arm64_tahoe:       "57c93e4c7a28d25608f2642a5dc2ccc92bc281f08e15d61ef07a12b4d78e5808"
    sha256 cellar: :any, arm64_sequoia:     "b3a65828a3a664e34d1e8942402aba2874f6aee068cf7997d25293f6e4c64b8c"
    sha256 cellar: :any, arm64_linux:       "3c03fec849af4e970772b10845613bef7205258d85e2d317fca40b9f8056c965"
    sha256 cellar: :any, x86_64_linux:      "98112c1ae7669b8c02db647daf6b631c0a51db2dfba537f72d390cef3a56d0d4"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
    generate_completions_from_executable(bin/"lk", "generate-fish-completion",
                                         shell_parameter_format: :none, shells: [:fish])
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end