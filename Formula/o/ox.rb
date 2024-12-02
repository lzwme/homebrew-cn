class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.7.3.tar.gz"
  sha256 "3ce5682ddb26dbc300b2c8cc73c1b49eff846642887f83d5030c470d1a89e270"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6153587883655d8413b987ad3d22460537a7dc7f906b2bada3318d9db304ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8747148f2e5774e16647ce68fc225fca26633753b5c770de31ca81d15609277"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f0a0726df8995a9f2266b58e9d35fa166a135e8659c53024ce473d15edfc242"
    sha256 cellar: :any_skip_relocation, sonoma:        "62cad7dbc5abab5d92034b8fffcdf1d0d2a0362d5b1eaaaba0a160e57b848927"
    sha256 cellar: :any_skip_relocation, ventura:       "7183ab8600575681ace720aeff2b69e2a64d98d981483f530e8c8775186ff19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ee04f7cd1d84eec056ae289999e811649b8d9e303aba3a0fcf1ffd272cc5f7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ox is a TUI application, hard to test in CI
    # see https:github.comcurlpipeoxissues178 for discussions
    assert_match version.to_s, shell_output("#{bin}ox --version")
  end
end