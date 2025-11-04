class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://ghfast.top/https://github.com/azat/chdig/archive/refs/tags/v25.10.1.tar.gz"
  sha256 "bb6b3e9dc8a25a9b99ca0fa5419982139b3515ede61092591afccb76fb8b773c"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9731d8efb07fc6d06bc5b259da60ea94d44292a360a48ac4d601baf0d2cd1a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3856626060f6c5587a8e459e5a9289c067d3fb1bff87690f9880b8c7cee3a06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f446ed4cb5826e166aae1ca595d0f892622def2024dbea9b762323867970468"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2e48785e9af0fd527e23e30b86454407d3ab563e30e008b37b90cd39f213b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ebbcddd73ee1867ea42961109c6fc988f62890f5460c609af35bfcf8f917c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fad0142bad85ed4a58f4b474f8d8ab2432f24aeb62cef027ae632d802ff391"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end