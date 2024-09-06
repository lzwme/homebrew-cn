class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.31.0.tar.gz"
  sha256 "c6a5769b298d772d64bc48ac06dd9a64b361d8fc5f39e17abdef3b961f72d8bd"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e251ee3092ffef87e4ebaf0240f83b06ad6d5f25c5795116b72dbd43c4920aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a7b319dcd0ac8fb4096ca9aa9b88b2903f83e1e949135f9761a9d4abd5ea55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42925d8a33f54aaaeb90c2b73bc6854d8d650a062624ae289ccc82677ea732d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "909f9719e0d73765691b778ec4b05fdeefb73193251f7add706350f59b4ca5a3"
    sha256 cellar: :any_skip_relocation, ventura:        "10225d6927a4c8edc40528bcef5bc1e0da884d4ce7f55fc605df360f296cab44"
    sha256 cellar: :any_skip_relocation, monterey:       "cb7efef5be1db0e4b87b1f302e60d14a1d39f09bbd16c34d77a575991f6ac0c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a876b3ecd8524a7364dfe7a8348cc8a89bfa3dce8907c4d626ea9e47c43dab3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end