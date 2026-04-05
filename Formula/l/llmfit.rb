class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.9.crate"
  sha256 "915bd9daa5b5fd82c39eb3d05d4254fb1a9bcda8ad6e5ac4f63dc3f45b3c49ca"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78312f375db741780735454d6848447152fd36035c3dabeb6f621de30b15c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e5401378c29eecb28ee499671bd7d4197475313abced2840f94a187e637882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4762aa50d2fd01ec46f0597e8ca1f43128c34b0fa0b63a3d243000e5f2fcfec8"
    sha256 cellar: :any_skip_relocation, sonoma:        "464ceaa498968171ddd9c11aaffdddd09d7babafab6c61f392e5a077d6df745d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ada2aa1e88a73ec654286b3eb1165d972a3cea508b43e273b6610b3309d0b247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db1af16fa721675b6c140c7cb444fde32aae373e50c95f78f0f314d7bc03354"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end