class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://ghfast.top/https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "d2ce3c1bcbf71dd82ccc092bf312f802009d5efdaf98ba6b3d861701be0b0887"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e80eec8b561f4b16b14afbd82fb58f5a205b06682248757089a4b1c9aeddd218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e80eec8b561f4b16b14afbd82fb58f5a205b06682248757089a4b1c9aeddd218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e80eec8b561f4b16b14afbd82fb58f5a205b06682248757089a4b1c9aeddd218"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee59c022f40c3b941af5d799b520e353ee4eedbb42c2055b2b67953abda8dd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03db9aaf5e035b3d83fc49ef890d880cd52255ef08ff17a52daa865bc2b951c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a196f67c16702ec9a5f7e4600ffee3fe67d1fce2b37d827b7dc607797e89af"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end