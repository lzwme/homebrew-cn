class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "7540f754acf80d1be9adcdc1b4db18b5db18086fd979465bfb3032d448c0351a"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25626c8074c9439d5fa3f643ac06fe4b993f44930398fb2cb0bb51c192e257ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b264942fbc6f1484d66bf033e2a3d3680b639d6b1d6921931ccba6504005af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd1973e2112d1d577da72c50662811bf1e1a0a6d5629ccf63f92b166d060521"
    sha256 cellar: :any_skip_relocation, sonoma:        "da08e567b24eadcc1b1cf737af433a239cd34d49dcebdca871e7971f19a56067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c18596a113dcebe54f5c182f9e11154bbc8bdc2ad5e929e8a136ac8832af6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc3954ebe377f310b227fba7994cb18f3285948a178d4dedc5e633c00d44dcf"
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