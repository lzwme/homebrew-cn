class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "e4fe7f01142faab1d7d33d36c005c3ee00cc71ee6d69af842e5dc25552cab751"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e12b486a024dd90fb5531739eb7fa1606506645b82a0e9db9f68af4ec494770c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8588a50c53ae0c854448c5dfccf2161e36245b93ee6c9b5f2e879e7ad6e636bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26301df1444a2c7ee6286ebdca2922621ec1370928dd9e106a2eb76b25b996f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ae61829b283f78744b79d7beedef92f7a0eabaaeef86ccf4f1b9013cc9b12a"
    sha256 cellar: :any,                 arm64_linux:   "0306f98312dbeb3f3739c2800031a9ae018aba75e07fb2d8cf333525bfd38b51"
    sha256 cellar: :any,                 x86_64_linux:  "ce8f4955cab16cd96ca9554ad223af01826a3b702c1b227e242b4311aac301a0"
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