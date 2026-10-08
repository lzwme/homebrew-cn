class Kiesel < Formula
  desc "JavaScript engine written in Zig"
  homepage "https://kiesel.dev/"
  url "https://codeberg.org/kiesel-js/kiesel/archive/0.4.0.tar.gz"
  sha256 "8519832ad3214f0d534ca572a8f94d6b5034eb160e9054ba42247908fee0f937"
  license "MIT"
  head "https://codeberg.org/kiesel-js/kiesel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "146ac5e4c884760f6a622cc5f8fc8f9a5d0982cbb4be9ab4265bc9ff1f41629d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c24d0e307324d1a3ee16027306803e258742aab6a266ad37ea9a20953ab6052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0676d4b20a9e7ab221a5b54f6596923bb94321906a52c6021a1ed8b2607e2c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d262f38e1de91a6c984b2f398f4c51c28fb15ed32dd046c15c55ef18e8e55d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5299bba490569ba8c40b9e6551716d31f8eebd0eea2abee61ce5538929913656"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion-string=#{version}", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiesel --version")

    (testpath/"test.js").write <<~JAVASCRIPT
      Kiesel.print(21 * 2);
    JAVASCRIPT

    assert_match "42", shell_output("#{bin}/kiesel test.js")
  end
end