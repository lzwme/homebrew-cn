class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.44.1.tar.gz"
  sha256 "04f78d7fb666f99370625d3ca79fed57fa8b116fcb38640430bf9666587c48d3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c545303d7233ad47c9a79f996440106e6e0e1a0b99e4e9908f01486962d335b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2fce35cce97a54fffd02f91c7ef3dabc2c479e14386b7965ca7d880bb6ac98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bbd4d4726d3a7b32120a906df2e5c556c1fdf497a224a6a6c3afc7c4aebd1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b1ddfcc42b9cc18ae6abfad7be3193e1ce7922f11abb5fa052e62854e1a09ae"
    sha256 cellar: :any,                 arm64_linux:   "71ca6b2838f6f5519e9722c699979e283274f44d9256444adbaff9d25c1a6157"
    sha256 cellar: :any,                 x86_64_linux:  "bb73bd4fdbfe336c15488589f6ef1da2dfef104550cde34123305cd4f23b736a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end