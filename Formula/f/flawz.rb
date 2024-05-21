class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https:github.comorhunflawz"
  url "https:github.comorhunflawzarchiverefstagsv0.1.1.tar.gz"
  sha256 "90ee9787f63f40478cdbc1f55f1f865bc0865053ee2dd1edcb8dca80a3d069b3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comorhunflawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a49657ac1199d597066d3b8d39300450c2fef8811af96ccafbb1fe893fab732"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24515e6105e9ec2e95a3e9b2c472e4d256a483832f9cf73f34d272320fcaa084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0106bef429194e9d72e0a95d435250e0a489fcc858d0bdc1a15fc395cf90642"
    sha256 cellar: :any_skip_relocation, sonoma:         "02970ee9a4f449e5b4087decca6ecfe37f0f3f84125ef6b49f74ff9824c6b416"
    sha256 cellar: :any_skip_relocation, ventura:        "3a5cd48a5996b883649b24d4eefc4c43c834f333abb3dcbf24b3dca58e36b418"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5fed225844f132fac9aea22de4de09aa333ad312a4dfcc5634a55de1a3a488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d1a167fc65c7dc3583b5594d7afec90f2960ae9853eb351f529001861f8ea2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"flawz --version")

    require "pty"
    PTY.spawn(bin"flawz", "--url", "https:nvd.nist.govfeedsjsoncve1.1") do |r, _w, _pid|
      assert_match "Syncing CVE Data", r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  end
end