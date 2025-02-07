class Chiko < Formula
  desc "Ultimate Beauty gRPC Client for your Terminal"
  homepage "https:github.comfelanggachiko"
  url "https:github.comfelanggachikoarchiverefstagsv0.0.6.tar.gz"
  sha256 "02e0672b22545669e32d93f1a7ef62ea1f1b98f2eea9ba354e536e2a8540fde5"
  license "MIT"
  head "https:github.comfelanggachiko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bf3bc9f7cf55b56f24b95bbc15efe3e72f2f7fb95306b7bcfd5a5ce888fc3f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf3bc9f7cf55b56f24b95bbc15efe3e72f2f7fb95306b7bcfd5a5ce888fc3f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bf3bc9f7cf55b56f24b95bbc15efe3e72f2f7fb95306b7bcfd5a5ce888fc3f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5d3d68b54b6978276870173f9097ed716f6028c92c7fd8ca7b97ebcf7ea7ea"
    sha256 cellar: :any_skip_relocation, ventura:       "0f5d3d68b54b6978276870173f9097ed716f6028c92c7fd8ca7b97ebcf7ea7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985fec7e611dd6be7e2925396906174a3f98fa543b044e311408d733948fe8a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TERM"] = "xterm"
    require "pty"

    PTY.spawn(bin"chiko") do |r, w, _pid|
      w.write "q"
      assert_match "The Ultimate Beauty GRPC Client", r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  end
end