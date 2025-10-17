class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "0fd25048c1498e3a54f7847fc6fc5119a6201c8c998f13d2743fd99795bac260"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92c5f9ce3d3a1667a5a8af4280ce35e4fc63bda358e69051ad76bb084c82e8b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7054e29f26f754d3c1ce5236badebbbfcd2157bbc42b68bf2ca7f44ca24f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc8e9123e1489ac8b77cf72842afa24999e270b794ff161ee5d913784f96c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "a739929cae35e7386f91aa59a3b00de4805c048a6fb18372e9afd644bf430990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e7710b77e165d932bf493949af92356f49d7059d91c27745cff8c985b74dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a7f4fff5d97a6c9377eb2509dd2517f56817c8aa9007dd4dbeb282d551224e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end