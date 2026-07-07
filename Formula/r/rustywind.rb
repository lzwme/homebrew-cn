class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://ghfast.top/https://github.com/avencera/rustywind/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "32d3bff8de2b08a17fca485994e69e33619a78b1e397d4059dc445f62d19603b"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd381e456306feea4c99931f12dc23cee98b4c9b4e446fa24fed883151790e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c906fe8fb182279bbc3b57a48f7c6c6f4fbf8f2d143c30fe689214fc28e453d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8fe0983a68e522449535738c75cb4c8f9a0a27dac3450dc9f9fdef0f93950f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d99079ad2acdf2b9f994676e4164c802688360cb6242f5b2200fc3fd86cb85"
    sha256 cellar: :any,                 arm64_linux:   "e7cef15e84b14bdb206c9041f0656bcb6ff223d0e734ec2e9771e0ed6a8d65da"
    sha256 cellar: :any,                 x86_64_linux:  "818a587251387abe5adbd256338efcf8c930892a4e064cc167c95530fd8b4f9f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end