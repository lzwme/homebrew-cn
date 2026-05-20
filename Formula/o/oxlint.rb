class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.66.0.tar.gz"
  sha256 "fa2f6542958de021b2dcac8b296a5f872001b6d8fbd7e295ef643ebb6c0f7ae2"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "111f9a52a3639318618cb755f1b53fb3e10f2c4edc93c4e1f4420d167a0687d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eec31c8dc5c7ac092154e1ff40d9c09cacffdcfe611a0665c546cef9ae30673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2743c821e681a05d381a597fb1ff65ecc78afa4e82d172579d6fc12f946fb599"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b3db13a69692762145522522c19c7bae5d8c6d779ef913b31b0e0d9e2af047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "881daac04d2036077c3f77813002e9f6989a332e4900789b51325030e5d88248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fae29f27c81387f355a316da9a754da92d862056b7ea6d2243e20a7efb5025a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end