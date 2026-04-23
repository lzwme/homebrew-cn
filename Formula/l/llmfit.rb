class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.13.crate"
  sha256 "75d9d0fae0e42022d0149dc7187e59ef050dbcc8f87862b3584752481872a552"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0bffed64cfd10784499ddae4b80e6437db9c1195a2820940aa978c72160f71c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ca77d834f98e177d725715360698cdb2a8ae9e99527179a6aa1b4d37c23556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f20750dbff528fe2b1265744659abf47090acbc808ea10b6b88ec718a7a38d"
    sha256 cellar: :any_skip_relocation, sonoma:        "826947f5c4ee5fc6f0a659a73ce1756de36cdcdbeeff2284ca1679244160df47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5b153c1462641d054369c9e2561cd6030ff8bbaef53ccc1a3f6cd3eae34741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f80117e1c822005674cdd6e4bad54e8804245c0b9bbaa43a686bd770bc6660"
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