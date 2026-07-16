class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "9dc05b091f7a900f09974d09df7391695c0855c20bb6494295d2c6a65aa228ba"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2464379effff849432aea3bba2447b45303c0f64f5c76266c077c486d06057bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b3860c8189dc2edd2baaf1710894055d4bbed9062bb491b0a1ad17b24c6eee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ba408e65dfca8b6db230e5f41ebc39e58809a146ec7a683910ae304a31da557"
    sha256 cellar: :any_skip_relocation, sonoma:        "9496c6836f66608b31901dc78a1195f1b5142efed9635babb7f5bcf0af2bbdae"
    sha256 cellar: :any,                 arm64_linux:   "b371bc5b70e1c5bf1c1c1e5572b593daf9aa9d9a55b84fc80144b1f4f91c5026"
    sha256 cellar: :any,                 x86_64_linux:  "1fd135adaab587e945ae9771955e302176a31202779d47c3f89bacf19c8943a6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end

    generate_completions_from_executable(bin/"scarb", "completions", shell_parameter_format: :clap)
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