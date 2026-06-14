class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://github.com/DataDog/pup"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "230a0eb0da963fe88c30a86866b6a0483e79379ff9a66e7901c5e7673de6ed3a"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f83dd836099e526c67161d315c998650f384947b836aaaee755ec504efdce42f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d57f30443a03f3c4c4712d42e9fd1032b707c9f7e2e59ea61342c237fa80326"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f22426e304af6f98d1c64e0a11a447d3ab248ca59dd0e0244df38b51462793"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f933bcb01400b036f5de3b76cbf7512fb9d4ef02b552abc7a9021868dab44f"
    sha256 cellar: :any,                 arm64_linux:   "7f876d2448e00b9a34d5261e20cace7723328723b36ca10ed64f50f9a27727f4"
    sha256 cellar: :any,                 x86_64_linux:  "8f971272b2f67f5947660ce1e15f0f776b15504252a7b25d2e489ac56202e4b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end