class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://ghfast.top/https://github.com/software-mansion/scarb/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "5875dd0feb1e0eef7b5dea5823f1e960b71cabf5b76ef49270fe8d14a29f308a"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e56c44467b7d05e3cd34cabb76802549a6233f1824812db67e2b532f6b4c2fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa25e5f62a3b4baff4d3680cbfcdb6636245ec462c454127b75321c89a2953f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbb82e931ad57db227efe67dd9ff15c7f916daac0807a08db1ad2ad6767c768"
    sha256 cellar: :any_skip_relocation, sonoma:        "484c10da32dc77ea03f3f8a3ed9cd2c6c107b668d17a5d94a6e3fd6dd8a45b04"
    sha256 cellar: :any,                 arm64_linux:   "a506ef5ac50eb4dcf39feb415c3a771aef79a1eba54d3778ca6e793abda6d3a5"
    sha256 cellar: :any,                 x86_64_linux:  "511cd99e39e90d956687af56d07d74ad83bfa172b5791715f07e2015a2fd765d"
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