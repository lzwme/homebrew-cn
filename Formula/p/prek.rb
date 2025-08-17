class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "3adf812af4d0329246914262dea29e27c5ed4358034ac9c4ed81cf1b95b80c20"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9e5345b00cb0e1879d2cd19b23120740e44467f3a4668a23bd6fd77d785595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc5dbec6fe7fdd51a3435879a4f7db57439931635145cbea783213a48eea4ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f7eadac9accf17785468a6c06013eb84525fc1fb901cd5b8c7447a84593f90f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea82ded2e09714880823028ac141cc904b909ba7de27f33bb2aa2a66d5946e7e"
    sha256 cellar: :any_skip_relocation, ventura:       "1537ecb7b6287aba669074ddd454f2d131aab41e30b6fcf5b5c977afed60daea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7edb2d0a9f47d515c4119620b66c9954ff065526d530810fdac03c79f8b814ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eedaa2500407878f73c043636636bd6f9686b559f9542f9644aa0252087fb55f"
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