class Flawz < Formula
  desc "Terminal UI for browsing security vulnerabilities (CVEs)"
  homepage "https:github.comorhunflawz"
  url "https:github.comorhunflawzarchiverefstagsv0.2.0.tar.gz"
  sha256 "dea2e679665ab8b9c2d39cca9911470b2ed0d57e386bb53d22de0774bac86ac6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comorhunflawz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee97b86aea995cb8b45b4aaa956feab6ca4d3a14fc3f8d3230d132a014acb637"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87c972f95962edbd64e0ce2c38bd24b59304dfc69e90aac20b5519558c429f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b182bc67624a6701c77e6544dc237e9e79cc2cd67f196c1fa63bac39e0e439"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aad7152ec76441919d0faffe9466ed5ed504008b587e01c20e54f74ce555fe3"
    sha256 cellar: :any_skip_relocation, ventura:        "82ff59d3d1e9731c8dbb33b7db3c481d274132c4b47c3545bcbd0fb92349ffbb"
    sha256 cellar: :any_skip_relocation, monterey:       "103d0297df5dd0839f2021c3270ab2ab8d58413e9dc44056b18b381fa6510f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05207e6b6415a7f593cfbde3fa8f08996854e719fb24ee6053a48c24ba33d343"
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