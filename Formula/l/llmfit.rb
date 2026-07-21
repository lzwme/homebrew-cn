class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.4.crate"
  sha256 "6d786d4e6d951b49bbb2771212ab3578c99422701b215ac2a9266748a66dd8e5"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00496fc162544a428090bcb86ca65f8670aa1b0c4413c8cf7982d3bbb1ee797b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e09869754b167f57c83a7a1723bfb601b46aaea9789f1efeff3af775d73be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e00f7cab778f1c94c24b45a14f79d7ec38fd4eb1b6adbd4d6927501b55aa43"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8a126644d82afbacc53ca8586641a048affefc3e68f13595f7afa2cbe709fb"
    sha256 cellar: :any,                 arm64_linux:   "569703c270e6dd4cb6ee01c98ac5ea2591fc683eac5e5433f9d8cc1cef374d40"
    sha256 cellar: :any,                 x86_64_linux:  "3cb6ab8e82c34aebb3242543c346022ec4ef2e38a68934a3278b150a0e45da72"
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