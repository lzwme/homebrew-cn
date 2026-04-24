class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.14.crate"
  sha256 "7cbfed2e9d22a98f13656af7a9a4bc8cf32031af89d62f8226b03c810dad489c"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "979dc0f347e37c0ac09b886cb603a272c1a952a864e6d635212fa58c1c84c6e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21d765bc0a2a2e676f1c56647e8a22ab80b6e2a5ea878148589e5949c15d838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a2d921e50945303e37d4bb20abe4487d2a7cb6308046ddc4cfd63afa1bce90"
    sha256 cellar: :any_skip_relocation, sonoma:        "6add4dbcc9339b94bd0045d4523b91bcd683164b304111288e96e924687ce7e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7633116936f557124dae3128f078047f916b1105498fa8b78e0bf3d9059646e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37489519bd04023be3d7d0eeeb88372619cce1e8af1df0c7c39c14d81a1023af"
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