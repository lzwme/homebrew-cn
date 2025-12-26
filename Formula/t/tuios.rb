class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "bb9b2d54ab5e9f14c311ff3f8ac7b0dc74484d7a474603bf453bca3fb37dfff1"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e773d99d170f9d72bbe113a751f3ad01ae89c68720199dcf3684b23ba291dd37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb53664daba0d9a55569a78a9670427a231e584a208eddbb584190916fc5cbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e2dd4464d03cb5490f80c11b8cd6857a41a96ade733c0d07c3d67b6c58abde0"
    sha256 cellar: :any_skip_relocation, sonoma:        "78857bb3723874240c7b02901fe331a08b0a9ef783a46291471e989b72233961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28b4a8dd1d82008141340306139f1ba4e10c2bdf20cf4ba080b3f109c2b7d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf8eaf490faf9ab543a1c58d0701693e7b815b5e31fabf64bb2f4dc38fcfe53b"
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