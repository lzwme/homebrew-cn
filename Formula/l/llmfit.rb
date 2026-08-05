class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.8.crate"
  sha256 "990bad25d164d6e5ced35c59277812cb504f623c84ce912e960550579a6378d2"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a498c4037ac38defbc10e2093ecd1af7a673cdb37daff601d79d78284e88359d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3560097642f697eb89b37c8696ddee945cc05ecc1e3740546a6f52b09bd122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b579b845c63e633323cf016d675f47f830cc14e4e5769f4871257fbd96164aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "78aacf0b8c8af7a34517d8535424399c002a4f025682fcbca32e6d676cf68c5c"
    sha256 cellar: :any,                 arm64_linux:   "605b2a8685caf7097b3b8d91236b7cdc06b8ea53a7632fb0123749902baf0980"
    sha256 cellar: :any,                 x86_64_linux:  "ee717220b8cf01179f505567e815cee9d02df02254ef1017247d72064bc87a58"
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