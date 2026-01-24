class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://ghfast.top/https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "22c487432743fcf6b5684daf23619fe7fe3427b1e54fb86b09dfe53dae8d9e95"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0949c3915c90068137b36e5fe5b46a81809ff481cc4c7d9f2842368a160a1939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd59533909c4763ab8d68e031f7315e48d166e91cf6bc06f7b35ba69fdec1fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "215c779c0e3ef6b1f320709812b5d359624b4eca1d6bd769f265441b0b7861d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "25d6e2040d3b131c65cf960f40ad6637def70fdacd24b6b4018a9c99bbe4c6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91e30d5ea6ef5802312ef905670163b9620a33d920a2da84cc4f4cc76be27cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910eba4d0509a730b23f0a0cd52d68651964753cf2eb067184b8bc008c776437"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["REPEATER_OPENAI_API_KEY"] = "Homebrew"
    assert_match "Failed to validate API key with OpenAI", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end