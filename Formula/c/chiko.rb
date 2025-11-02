class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https://github.com/felangga/chiko"
  url "https://ghfast.top/https://github.com/felangga/chiko/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "3b345707bbe64ce32832de5633722128c566ae7538dc64b16bc71657d71af737"
  license "MIT"
  head "https://github.com/felangga/chiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40bd4f8fe02009f8091081b96d71671733465e89cba12f91ea4c8143e83ce464"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40bd4f8fe02009f8091081b96d71671733465e89cba12f91ea4c8143e83ce464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40bd4f8fe02009f8091081b96d71671733465e89cba12f91ea4c8143e83ce464"
    sha256 cellar: :any_skip_relocation, sonoma:        "d21b7229e25566e804edbb72c60baf9b35aae035a42ce44d6f80fdd258766340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5142ae134d09ee4d591f0f7ccec829d5fd3f526bfb9d9803f975aa8ab861d002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c6dc0a7efc00433416340ad06cd4e3b927c1937754c802b9570011e902bdd27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/chiko"
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin/"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "The Ultimate Beauty GRPC Client", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end