class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.10.crate"
  sha256 "ff00d372114d934074c9461e8cafebe94e99d72bc9bc739cb58179a8122785f3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f786b4057c5b62c7dfbb57b767c3d0f120cfb21a43834f1633c587c046cdfbae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c2085597668653414d782ebb3ae76ba53751f47e070e1d51478da5179598db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bbbe89313bdb5143b20233f333997d67e2482c5c3d645fe3dcf0c67c6e97d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c5d2ec851edcba97819580d9c66888a6900c54b67e5c7a5add4138f950d5bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d14f74aa05c5d1e1c56d7484175f9d992434cec22c1c6e9f2973040e3b91654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b61a637089d57117e46f49f0b58d309de49a5a7b3c1506c0bb45dafda5ca61f"
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