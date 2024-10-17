class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  homepage "https:termscp.veeso.dev"
  url "https:github.comveesotermscparchiverefstagsv0.16.0.tar.gz"
  sha256 "58f3b4770c5d1c5d7998af88b6df8c6a53dee4409f2cf6ea676caccec79cdb7f"
  license "MIT"
  head "https:github.comveesotermscp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53d33f7bf81f2bf50884bd90699fc80607507e487326c46d2ef441a21113449f"
    sha256 cellar: :any,                 arm64_sonoma:  "fdef827f27c4614f4e997701267e9885c5898b5f6faf3c8815c4ddad0b95ef4f"
    sha256 cellar: :any,                 arm64_ventura: "6686447fa6bf9e09bb79dacb838ab4772f90b3c178f7b5d86182ac6add80d61f"
    sha256 cellar: :any,                 sonoma:        "61f2ce84bce6e048e7a07856671fbea8821592023070949a5647e366aacc619d"
    sha256 cellar: :any,                 ventura:       "9a09d6cc66fa58721d1ff66efe7c3462ede28b3a18f84bdcf2fabc573ae54e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a911c8cf51239d17d83beab5033237f90614f9524dad961107a5d513ffbbdc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "samba"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin"termscp", "config") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end
  end
end