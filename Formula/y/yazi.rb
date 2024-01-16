class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.2.0.tar.gz"
  sha256 "65c897fbedde55bb5bfdd81a9a4892ecc8a65ab9b2aa76d2faa56a64b1f281a6"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bede36e75f06be786f7de1b79ff2af8d602b30b0fd8dea1123718ac8010a001a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20b93e66d8323982c99d8c6ec10b14d30e4303cd2ea86f20d01a344fa22a3f67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b2b5033889eaa5c5ed8d3372cbf96ac038c63840ef8fada962dc61af740a603"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a2f7b790cf7a6cab20fecddb24a3f0735c214edb4f00179dc4f7a8d99c29d73"
    sha256 cellar: :any_skip_relocation, ventura:        "86380b300d5bb05dcd112fb3aefa719b62f58fcf94c935360efaa1c26c500243"
    sha256 cellar: :any_skip_relocation, monterey:       "f85d31a38aef1b22d13a35db9c432220923d72f55da9b6d16d2837be41ca4958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86f30480159a875e092f51d2f951fca6b4dc9a18de1cccde893bd4ce7c1c595"
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