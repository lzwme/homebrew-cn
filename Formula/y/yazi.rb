class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.2.2.tar.gz"
  sha256 "ce830fc312fc7a9515abefbbc71c8d1a46515257e9d1c56165cf6ff2fa5404c7"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd9fa637b24454ee09af7762ae59417b57efad296dc4c7544f6bf7fc9ae66ba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edccf0ca76d4560a5ae8083d506c98edcbc49f35377e716fb4c02c7accbb91bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aca37bac6afbe000b4a011cc2974c6af3e7f10c5d038c28c2ca863308cff2a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "66b52fd5f1754000ee399a1fee73ec4aa2c9a007a78fdc557e32a9a82e418f7b"
    sha256 cellar: :any_skip_relocation, ventura:        "23b29c8dccebf16493b2998c8c07526c215b92a0161f4e8633ea5f5db9d6d46e"
    sha256 cellar: :any_skip_relocation, monterey:       "6decf85d08323b269b0604da5d07962d1fa84007f1fbfc39c5e56c815c523a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34aeede9d9e9eef58e9009eb3acbf47306efaa808d157c4d7ceb6806669ba43a"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
  end

  test do
    require "pty"

    PTY.spawn(bin"yazi") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "quit"
      begin
        r.read
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match "yazi #{version}", shell_output("#{bin}yazi --version").strip
  end
end