class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.6.1.tar.gz"
  sha256 "99135a0825f0fd604bd060699856dc0a4b79179807c6345ccf85ad33cdbd7db6"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3691df38ac0456cb8cdb8f35904b0a53fcd6f0e5ab09beca0c0cc25ac53c40dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c58193b7dc59c5553e139a6ee90947fdd286bc871cc685c996e9998ca9a1143"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfc6a4f5a16726a530e40bc3df6cac24f739d8c228ee12c1dc0908ccdde96441"
    sha256 cellar: :any_skip_relocation, sonoma:        "9852248586759587a4c6e9db2bd6378ee349e4e09498d05ceebf6e818a4a5058"
    sha256 cellar: :any_skip_relocation, ventura:       "3165b9ab51b529f8021b629944edf410ffa5c57b7ccc8961568391ecec5904c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f67c3b29cdabf5be2fed47696ba3144702fa0ae358964ea36b1d26149ecad27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end