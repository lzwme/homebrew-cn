class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0a64b1381b276f00038ae05e8ab8963f486a8f0d7da09383be84e147e2cc7834"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ef8e2a046f473ae51ea53aa8ef8e820adb52a8c23d2ac1bf7cc33588b193e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3530c0ddda1efbb98c1b17f30598b5e8e16f61b98859eb565257c3d4e142e34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a62a2839c34a9d120ae79029f696e6480b655c1881802d757635b91b0d4128f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "40b3de9b4a9f5a72984b5d0a599d64bf4021c344d7b676fb5b7be4c00e42ec19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6386c978dbd5d2dbf1124cbb5faa9a44e571909202fa85bc5c51b5e80dc545d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77df1265a6c39140c25c10f0a384cc43410cf78eee5f5f14e036fcf39fec67c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end