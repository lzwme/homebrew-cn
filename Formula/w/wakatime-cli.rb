class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.19.0",
      revision: "0a8c6760f4632dfbded7152546ed6b00b9edae9d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9c12bf2caca5786cdfefb35599aa27300197d0b8dcca253c32c4f79fe43b465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c12bf2caca5786cdfefb35599aa27300197d0b8dcca253c32c4f79fe43b465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c12bf2caca5786cdfefb35599aa27300197d0b8dcca253c32c4f79fe43b465"
    sha256 cellar: :any_skip_relocation, sonoma:        "406998ac6d20f9c3738bc26e39be7ca49b6f75ef7ae2a82121d9def9876da2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627b33bded7e02e0dd26f4a0f0310ce79ed8d4cbc53eba78aac333a52ea9f312"
    sha256 cellar: :any,                 x86_64_linux:  "bb4dbe5bbd0d9f636d6626a875aef8cb971468fb0dae870fcef51f1ba284680b"
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