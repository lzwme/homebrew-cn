class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://ghfast.top/https://github.com/anistark/feluda/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "2a869288fec7f6edad343aca29571215c94e7b47eba93e93dfb9f3ada8ede2e3"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5a79e16db9aaecf862c615a7685d40670b76b467e7647c7b2066b7422b0c26b"
    sha256 cellar: :any,                 arm64_sequoia: "11b51281849d161059d2764ad69ec67b6f6b2ccee27c510dc8ae7a00f91f8113"
    sha256 cellar: :any,                 arm64_sonoma:  "1ce8fb8e97f2cabad02bc52c18bedf9e59e9598206038fcb03f20dfff8864284"
    sha256 cellar: :any,                 sonoma:        "edddc53a133468675c3cb6b7884cf6e42c9dec9cde8974b633bfd9417b84c450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb0d80afc80d70bc034a675add404fe998cf76ecf14f2291316172df317c4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efdb784efdc278b3568b01d301d79cfbc6226216079133e746f910523249e27"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end