class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https:github.comorhunflawz"
  url "https:github.comorhunflawzarchiverefstagsv0.1.0.tar.gz"
  sha256 "2460f8c5f825e63e365956a25e806ba28ffdb5ebca05046e9932985ecda84c1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comorhunflawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a33ae2473ad7f35588247b7261a6824537aefdb37bf6d4178cb235f979dd9890"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e253bfe7867abfe9de6659afd93898cc25dc5ede79589e09045855a2a920e901"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d2ca25b51c912272254e350821e642ef49b754ea40b244484c5757e7533b87"
    sha256 cellar: :any_skip_relocation, sonoma:         "08700e456f037d170f2caa015dfe0e9e30e432aa203ce390874f5c0a5abaa477"
    sha256 cellar: :any_skip_relocation, ventura:        "20a70c173087cbd1fc428af2e9ba74f7fc835826ab11ba1f793a9ceba3067f30"
    sha256 cellar: :any_skip_relocation, monterey:       "15c9078045da282c745b096b8257c4dbc3ea36781b85a60109b7e63712ad1251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc410f82a153c5e9878011ece70c9c7e67bf55302ddcb3e2656dc2d92e47e95"
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