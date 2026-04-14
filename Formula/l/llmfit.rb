class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.7.crate"
  sha256 "a9b104837635e9cae6371c684783cd6c4b9fd488cefa401f602648b068c15c58"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c47144d7adec3c397c0d6a4721f074bae89e3bce0849aa81276d74c8ad12a4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafca4ab10bc46a30e4197a935137b9c3c0125973de43dd38cc416c6ecce5bec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8433e52318b5fa7ac7f9c0223b72e80f4274e3fcdf1bcc6beb4cb149f3e94508"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b2137751ed3d82e27012980d63ebdc5397e552f019fdfbf28264ff5be110fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7f266af43c4ad88cf959f87354786e64c1b605a680fea94de3a88f5396def7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708c601b407cb06c362fa2aea6681d8f883ee9764edad57b93f6ae7c59c2bc9f"
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