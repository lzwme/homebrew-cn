class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.30.4.tar.gz"
  sha256 "f6521d05860db8261b67284ab9349d0fb393186dc3f7f81348c603d234179148"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "133088228844ddd85cc070fa36f00254f49a95929fe3f749f4ae34fd3df89a8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1fca11107277f6b67fca22265292aeb2147aa1bf4a3a8c6d9e3ad61faf36dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16e3a49c25886677858098a1b8d9d346c8ef849c4e3f210fe5d42b6b94d23de0"
    sha256 cellar: :any_skip_relocation, ventura:        "169912f816ff170670ee59a22a028770c93f43754b0fa37ef9eb42e60dc893e5"
    sha256 cellar: :any_skip_relocation, monterey:       "81f122d19aa5aae742dc91d39afac5634618ccc228257b632d8170fc01ea71f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "28e9cecdf1a2252b0c7b29fdb9c293c189763948708065c7478b8bfd82ef014a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d4dc1054f509910564445bd50028088120a1a90a9133755ca8f5cecb8c4e54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end