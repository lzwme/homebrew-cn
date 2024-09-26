class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.40.0.tar.gz"
  sha256 "cbd50e53bc1e57e5d5d0102775cb1c822695acb5024814be7eeb78e654e046df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90bc49decde5878fa7f19c95122bb8cc9ee98684510b8ad62e864a7a9c603c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3290f96e5244ab9a66cd0c4e8558eee2f7e997d32dd29eb3a88020cbb4e7b401"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf8351aa6d97599d78f0ac6ba6990ee400f9c6e093bcfef30fa9a47ec21b14f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9aafcc34b5d172e399b934c6f52ac43b46613a43fcdb0fe17723dbec9aa11b2"
    sha256 cellar: :any_skip_relocation, ventura:       "7482356c3e5bba5453731e393ee02737464052d37ae12f6963c86e71ed511502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74063d1ffd6cb25e1fcdf42dbca930e2caa81ce4843c4c8543f83c02cc59e923"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin"rye", "self", "completion", "-s")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin"rye", "add", "requests==2.24.0"
    system bin"rye", "sync"
    assert_match "requests==2.24.0", (testpath"pyproject.toml").read
    output = shell_output("#{bin}rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end