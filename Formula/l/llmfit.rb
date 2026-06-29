class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.34.crate"
  sha256 "d5bf498338016b12b9e52cdb6c82e93a5daa1c27a786e78a608505214ad154e2"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dcf6fdcf7772d18f670fe491a6d577bcd9ac4bf137f2d46edc21606ece0db73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7afc15a0b93d7af88500d77966979aec9d471aaa9f046745d3feaf157ef9518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640309923dbf1b92775b859f7c97d8cc0f695f81080091d8a7aa5b026daac152"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fadfb406aa5ca2be77b8f657a9efbaf4f1e29d6080bfbd341d12e631a0b558d"
    sha256 cellar: :any,                 arm64_linux:   "3961cfce2491756e32a6497a006f62354b5236b32d1f7cf58fb6e275ba149c83"
    sha256 cellar: :any,                 x86_64_linux:  "d506c6b142a49583bc4999523034b0dd44dcc8b5294a4ced5135de656bd3f1cb"
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