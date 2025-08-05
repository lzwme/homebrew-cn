class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "ae8c66cc46213924288f1d521b1611ae132d92a4fe953e6f07c687366f872162"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b6ee51c3803785a6e2a039ed0e5a3f45216e9b25f0920b3b4124b616eadca69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a100c6fef967453cccfc4140523c9551e040af25ad5a408aa7b58e29c174e23b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e6ae99ce1ba2148d6f277fc458732050c03fc0a28d52ffdeaebaaceb9d9c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f092775bd7047d5e1d8d758bedcc16fca76bd0be3843473d1a2ecb58789ee27"
    sha256 cellar: :any_skip_relocation, ventura:       "7d149c0c7175793f83c3e89ef487bc72ff9a52d08f5b4cab62709f0de619dfd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f5d3afda140b4e3ebc9452e7add3be0f90a612adcfc2bbdd84be3c66d265a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b5d7f93ad5f6ef1b8ee51644435e81e1be1cd1ad02f08439e29f66785b5aec"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end