class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "f40b52e2633a196ed8b98288c1042876f31bfe6fb6df1a2ef632a66b4ce2d82f"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2b824bc0660c1fdc7361b2de98ba612f95cdde10643c312ffb320c6975c8e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91d8c75c089efc606288fe295677308e2cdf978339a8a4bbf9d0883c4c45bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3443104d1caf1f132b8381e7b64cfe0c44aecfbae2f3143ea4853955a7c9c3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc33896c16b0627cbea0cc81fdfc726f17c36bbba8a34cdf1326c94f28adac08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e88c137d10fbf3bd36e4a93ab144b6a5f714819c37feea1d317ed665bd544fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f238b2e401472b50596646654dc628195858c374ad5dbf62ad7c885f018ddf4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end