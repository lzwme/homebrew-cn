class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "162237edd6874068e2ec6340ae59ad701803430450e18bfe335ff71ee2c52866"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992258d7bea5c3327554d5fcb22a44594ef7f0799cebee9271c76bc4dab773b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f65409a7dfe9979c1c594fd88f0a5917f22d2c459e880f54c5eaa00e23292620"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11a64adba90c0f13118a6f1fe42f7b02b8d53fdc074e8a060380a0ca69935774"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb7064026d8d45dca63c9cd582228fc501f0eb8b31092d0054bb0bb557e2ed1"
    sha256 cellar: :any_skip_relocation, ventura:       "da7fe940b5ea43304b9df74aa59e3e2cddc413854fb409ae51efd5a61e04b98a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3a4b569b7c08c889a0b43cc848becfa469809270ee77e735772e6a965fa04d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ff9e5cd6a4980e34fef6ccb38598fa957619eb4874010db7116d3d56997fc7"
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