class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://ghfast.top/https://github.com/Skardyy/mcat/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "e74f0d4c7dbad80a7684664c7694810b08784cc45412ad901daaeb5a25368a63"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9314deb35974485750eaa8b87bcd9a2082db0092f48987e80e51d4a5b89b6334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c2b59603f71f2e18d4177aad460cf1a89ce338c1fa26526aa6c79b877d2b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c8691c08b5ec6fbb3050f9efe142f8307f4ab081cc73d9ba9c866e4f0ee02b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "78b6265dbc76ebc31f01a2e7acdfecadda2b30360dee0305e224f9c4982acfae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36275d3956381e5203a3975a736d9c3603792f58c3dc83c68523181e52ca11e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e914f9dde922312d5a6b1ec38a1b83bede597a1ff5970adde38361a98c1e4f67"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end