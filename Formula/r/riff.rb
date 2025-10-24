class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://ghfast.top/https://github.com/walles/riff/archive/refs/tags/3.5.1.tar.gz"
  sha256 "0f7a023e3fc0fad8822aa94e52d0c70ece5f0bf1ed4b4fa56d5f12d739bd82d4"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5951197a99fe39e9c4ff8630c9d1bf5d9261a8dd7565fa944e1e07c627e6349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dbd7b5e33208aa49fba8f138ff4a599e79608aff5b42fa71dc0cb274f699a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f63a6fbee6d6e9173a08176c3823c7047400170d3bc59d82af97249bfca163"
    sha256 cellar: :any_skip_relocation, sonoma:        "66fc24637d6af8b832d47b0b80cfac74be194e7b447efa2e77b247833eb476ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97dfe32c622a793cb8d2e4aa2fdc653d6300a5ecd907877caafae1763a84ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e64e5b46495ca011e961a048acfa68f1f13c21de10f3d9d75456866ec976c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end