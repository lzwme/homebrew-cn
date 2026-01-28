class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://ghfast.top/https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "c0d6926615820a46f35c1f8603899b0acb0f2d7096d0379e0a276367f8177d36"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d26548e401e1e9a044790a0521b3189c577cc94c2cc56ae6a9cef998c6c3b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6677b1e8fb2527ba148b1b93eb69169a4ea089a3d351f91d4ce3ad4ab34f08b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6acfe66da6422ffdfc2c8923c00caa3ec3b52ffd7cbbbdfe1679d544e1ad3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb6748e1a3ac38098fc3cba403163d60dba099c575c5fe832d83584e66a6e4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295a09563d97f7af04c3a55fab1725c0c1de69fb0513cbeaa52956d2dc43e300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7a35600fefc23b5aa7a536cd20cea4316f43ca23edd30d5473edf8c1690979"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["OPENAI_API_KEY"] = "Homebrew"
    assert_match "Incorrect API key provided", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end