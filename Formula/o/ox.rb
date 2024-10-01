class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.6.4.tar.gz"
  sha256 "1659cd539b9765cc595479d1461f0a5b14f5fe5df3d3322fa882542c94b320bf"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e36107976deab2e61eda179f7ecbc47ba0871b0348351297b98a373e869e8d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61b658c5ca6a36e28bf70308d0f09cecc47ddc309679ef9e528b93924ad01d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2020bc71a0884b97ff1df57532f9c93024c6c49e0284f014fe31f5a8242392fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cdf86ab595a7d970b2125bd5149a1b728bf51f9bc8951fae50017c079fd93f"
    sha256 cellar: :any_skip_relocation, ventura:       "a0607bf83b01b753fa44f09c7035047cea93558f49c584a9d0a24949f0ebde4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455efc8c57a1e7180b55f41b1d7aa71a6be8d23e1c2651a3643e101e60682053"
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