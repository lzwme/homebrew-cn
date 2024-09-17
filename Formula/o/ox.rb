class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.5.3.tar.gz"
  sha256 "a716337e1a830e5fcca709f761c4c8e0651736251a66a531c38293d9f7ea4053"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb7a752ce2331b658a252a3d1e969969e01a3883b187ba7cd5f693ae297a61cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0084d5e4fbb8943e022da22639c96fcc060ef669d782054fccad8aad857c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3378a0275c207fd7ce61de9a6cfa673253709398fe22c46683b0a6d3e407a580"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6010bbe6350e37323d7cf7f3d3306188ea337150a364f3f2af0b08b05b81aa"
    sha256 cellar: :any_skip_relocation, ventura:       "90b070ec548e5d84c2c145b654a2ee38696f381edecc72397449db7bfbce41bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06d0d7468d62522fdd41cd55f048c30d3a9023a1ac2742294e5847e0a98030c"
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