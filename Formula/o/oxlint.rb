class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.11.1.tar.gz"
  sha256 "1cdd3fb54c1703dddf27ff5dba2c29d00b4bf9bde013075755e686524f1618de"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e10355fa2e09a32d68704f9dc852b869d67f84070f5de8c2f9556c2a5c4b593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3966ffb42325293d5c74bc34e0de398c988e65a9b81f6def468cc1a491ccb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc47dd104e011add137c1ce7d4c659850b3ac1c79c0c79078c85540739a3ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c289b0d68723508c6785b9fbe5162369d487bf10e645a2e3e2c5be57ef424b"
    sha256 cellar: :any_skip_relocation, ventura:       "878a136e5b4b7f003872ee05fb749b1d712579110c1d6074b1c84c09dea0c3e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be2243fa3df7a8452c5e267e4e6b483ef3b429c62ada6dc525ff7bcfff8b5ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20ea15dbde8e13231eaac05b0b8fd7383b6c9e8ee361ab4ef0d099708bada40"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end