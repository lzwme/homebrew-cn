class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "be365d6a7568193655f2d049b2f2f95c8f27fd86bc3e6d15dca9429631ab5d12"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272db1ee0407bd7de8adcba6c292a3abb207e9fec4d7d5c23a45d889947fbdae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cedaa67cb6314332ef9054c9e2140e4a5120ce58312a1c8b12a542d5a0a6ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6b6afe3c26c00986e47616bee8e7fcbe74629ce950ceec179861f2460672cb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b67a451e54a16b42cb5c68f96b69acad44a01a5b51eb0a98659987c8e74cd1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b13d350746a11bb04ca911d81489684e512208d1fee651e82501b23d236c757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661e0452fe27db4b0e61fcc738d3335ecf250cc0e63e142176bdafe47f2a16b1"
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