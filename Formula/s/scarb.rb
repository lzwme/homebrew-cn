class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "fa732a5fb6810fa509de8aee18377f18e7470924771ccf0ac065ee690f361874"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c303a28dc4d4160b23704474a8ddf33dee68c2017ff6094dde01aa62222bcc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7006688fa0ff6337599f738533b4ccf8cd9a8165c349266921d0fb9917614b26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32181f8ea8821916778f6822c986f0da5e48ac49298e2b6c9136225b0f856eb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b311f59e09baa5fdb81a50798815489e82e2c1d4cdeaa1deb457a14e981affe4"
    sha256 cellar: :any,                 arm64_linux:   "e2f55ac46b6b45110f5b94502b28deefca0098310f83e6707667c70ae1908daf"
    sha256 cellar: :any,                 x86_64_linux:  "6b5171b6d5e98b7b8cfdc27038e7ef2afa58174718aed465ef316d572abb947f"
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