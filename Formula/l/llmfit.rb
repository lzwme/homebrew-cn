class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "93e6f82c698e34f0b19562f74369d8b66c193110d6bf29fe113088c7d8f36110"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc053521e785aa39de2bc9faa554e5227c1da6268fa36ac05eafaec62bcabd38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed0b77a5c8bb2fd5c360517957b3dde7a37904604f66262c72a1bad76cfa9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac44edb376e0840cc2f6923cd1cbbe1aebd505552e46c663930e454cd7cefff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c961066c261e1196dbd491ddc9b1a0827e641d7bb16cf89bf8fe5b46f46b8d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fd6ab6a177c03049481f4940a786a4754fe03cc82afda87c8dfed9c1e54694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ac989e8848dfb8ed7dcdee072d466fdc86c7dfd77ed08e7763139c7356be48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end