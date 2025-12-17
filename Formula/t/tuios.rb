class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "76e0acae946d7ec7549269be610d18b17abcf55d54e9ad683ed52808794a343e"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d0619ba9de1ebb1095a16179c0f7e93ea7b82936a2b7b07e574e76016e546e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404133f5adc9c97bfaedb16553a774ce1cbf0e47183c57237deed0dd74fc2b7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ad8364d3baa3d3c411d07f28dfd08533477c11af27544cfbb0a242e1f11adb"
    sha256 cellar: :any_skip_relocation, sonoma:        "50302de9f1ead63ab9dcfed223c151cf5841d843f7d785ca01742b6611eaa3d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cf9776943c6c4b3806399e1ab4e02565b0ab2d572507e0cb6db4a592fabc01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8201d492c605d0fc71ec997dec23726786bbad10574f934f304e18d08f7eff3"
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