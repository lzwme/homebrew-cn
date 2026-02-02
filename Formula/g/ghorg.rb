class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://ghfast.top/https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "928f0ddb92a62295a9bdc8dc68fe4fca80991a1c410e2392011dc2c4b04f83f6"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5d0452ec6ae5363b6c89c6d71ea56e0075b594e34b4703ddd8971c9d35a1c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de5d0452ec6ae5363b6c89c6d71ea56e0075b594e34b4703ddd8971c9d35a1c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5d0452ec6ae5363b6c89c6d71ea56e0075b594e34b4703ddd8971c9d35a1c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "10faa30db9a88c1a82a5d8bf7b58bbb9d70e17c330f41a61be8e51649c9c0566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c69e7fc1b556faabec5efbe5b5499098bf8f109b8b130aec92bf2c440f9e8d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8433443d5a7d474b0f8dc010f21ef01649f022e33ce3c0792e96b7f9ee9838e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end