class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.4.2.tar.gz"
  sha256 "3c14cbf499f1f260a08593a38ee6bce692bc322dbbe5441e41f3e4a7c9e811b3"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1d1e79bdf0c30347225c9c5a9bfdf5cb8ba112ca9b70381a0cc46f62bdb595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2b7fbbc98b4fde2b803728a4b8186a4c9811d881acaa1880fd1952fa3b27dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b47b8af796173e22857997780e587145d52c7e8f7ded4640585f058fa60f05b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7b31f1bc613e21358bddef9f935d18bb24001c11c1bf9e7b8f990dc26770738"
    sha256 cellar: :any_skip_relocation, ventura:        "04dbad947c201e1f228345134293fc6ad017cd4ed1d1d39b0502d46f3eba3104"
    sha256 cellar: :any_skip_relocation, monterey:       "e85fe56ea917a57aa56e8adf4e0e8676aebbda28fe09f28374733b9b20759372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199c220ac410468c64b0f7f5cdad4e160cb0b1ca031f0db5735a833442991a6e"
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