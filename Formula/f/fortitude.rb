class Fortitude < Formula
  desc "Fortran linter"
  homepage "https://fortitude.readthedocs.io/en/stable/"
  url "https://ghfast.top/https://github.com/PlasmaFAIR/fortitude/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "883d2b0448c7c81e380f07fa8d46780cb9503cd0be9e3434945c702fd18016ec"
  license "MIT"
  head "https://github.com/PlasmaFAIR/fortitude.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fba43909d21295d500c2c58746e768c7f037560f7b6d9af5c914be7042870d1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "979994d2f0eb0b75f2bf0af694321efddb24b0712bdad50d00ade7eaab9d8656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "013d6cdc6fe8e921126cb718c7a00b3c239e54abaa69ce3c41413d594b7316c6"
    sha256 cellar: :any,                 arm64_linux:       "8156d2ff6a5b06d1ef80e1edf2e8e0bbaa852db6df372b969dce4ecad97cf2f4"
    sha256 cellar: :any,                 x86_64_linux:      "3f6c452e7060a6892d8c0ca3ab60f1088bd524d6a70936306c6ce7758f61e538"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fortitude")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortitude --version")

    (testpath/"test.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    output = shell_output("#{bin}/fortitude check #{testpath}/test.f90 --select C001 --output-format json", 1)
    assert_equal "C001", JSON.parse(output).first.fetch("code")
  end
end