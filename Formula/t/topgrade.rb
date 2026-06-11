class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://ghfast.top/https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.6.1.tar.gz"
  sha256 "c25274461f61b8fa469c1645a892bb5b52236bb64dc448152c6f485f9ec1cb1d"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36eb775ad2b6cb2f30a1ea4f05634e5df8a2a7881d938d2473fc699f62d93682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c075e343a0305ed449069ff3e8927aea06c80e05fe5be253abf00d075066fee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe85fcc548030aa358c29e81618b6ce12131c56e9423aa83a2e66d8acfc1ea6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74271afd987a3b6f0a4ad2aadf7117af6eb0eff5384ec69ec2e029f5ed1ddbe9"
    sha256 cellar: :any,                 arm64_linux:   "5f1467716629f5d32d2e1386ee380fb41705ee8ca13f2281b87c83e4969c53de"
    sha256 cellar: :any,                 x86_64_linux:  "3f259917c8c18f3f840d6b1bdc16010ca5f7d2cd40942f9211df69090f27202d"
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