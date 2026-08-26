class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.11.crate"
  sha256 "bb8ef979e20c08c5d7739dbf07d3eee0600ec5c6294787dd834a0f71f88dda27"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d6b970d1f790395198a4825e49155cefa6e3414068acd940fa46489e552896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacdb34f7e39d2a335530551888fd03a888ba64c8832ccb393054c904ba2bd45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "444b3890deecb5129f023fe81495de76629b6bb34fd570a3109837058b41d64a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4df91940758eacb014896ec00506c544bfbdb46edf67bea21763913e832614"
    sha256 cellar: :any,                 arm64_linux:   "c54cb5d13bd23b63b146f2e218c118760c216cec57b2a9cd3eaffdd2708da670"
    sha256 cellar: :any,                 x86_64_linux:  "28014315a4b74e1425c2f8c275d61685a0403ddbb5ed4bb5ca169b4ea9226a4f"
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