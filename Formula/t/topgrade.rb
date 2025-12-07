class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.6.1.tar.gz"
  sha256 "e6fb3c7ef2c11a7583c0668d3b4b19873376fa6d737d7c7b5356f4426d326c14"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57951e2597a1b8b6ec7ef9cddef7ea385c2943ae7ee3fcf3ec7c520b8dbb05a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5abf876dba95408e4b594a4958b9b52330ab4fc596204cddcf1590a4207b3c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a9821ebe73c67b6d84564674f95c2a17ab2841386286b4ebd171feefa688070"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bee16cfa8b7df1c15179eb99a8f20f13c591421bce8819f94124f37a8d7958e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7930c30f96c161d07a8d1ed7e16aa9eda90d26c30aff06a7774a19608f4a3cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8539b1ee836d3f1ee20dfe48353427ed116c541440a80c78333b0088af116c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end