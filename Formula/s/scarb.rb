class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "91e6a2f9c3007e7a969db06c4865bafb015caf5b2510b8fa6afc5d80a2eb9e4a"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef99fce7dab00f7f69fd21e821f05663c673d5815ec6f2284917f2f509664bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e206b16a9c675d9b477af9acd3621833dbd2d12d968bfba2f7f1615870b0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840a6b054d3ce7fdf7f5614bb6c862762dcc2a98a425338df82c76c3c4eb48d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b303d8eb19b22fa4d50b7119bfa8d01d32f45bb17a9db6d201ba03f8791bbd04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "848cf282d5428df96fe537328994db9cb84357c72d9a8c9d8644f07358ddc328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0a854de435add927e97ca6b4ccbbbab54f5b4e4ffecd8aff54168825c02d86"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end