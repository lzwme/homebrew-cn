class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://ghproxy.com/https://github.com/orf/gping/archive/gping-v1.13.1.tar.gz"
  sha256 "5bdf36ffe6a8cd7979fdd54dc48c76ad96fc65af11929e17b3b686992d32e541"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d010fed26cdd4c51bf8f3f250ae1bd81f3aa6ecaa7a3e1b10c0d2ea3625310ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044f5d16a680a3d099eb62b44594307b6c1d9712fd01ebf15378fcc81dc8d393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10c126748f4094e5d9c82aaf917de097aa6accdc862d9f91498877a3475250dd"
    sha256 cellar: :any_skip_relocation, ventura:        "338447725adbf6e8dd74c16392b5660b4cdd34065e14b4c2875588549b5847fd"
    sha256 cellar: :any_skip_relocation, monterey:       "8ce1856b595daac0d669fe89c8730991d7e70c70c7a57aa9e96e19247601710d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4bb14b786ab5122293198f0f6c3c568b2f110597963097aa974d8a0f3a64dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33ac75760676ed00898c30b790a6005dcacbf32259cc801d0ea7e29e758433d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

  def install
    cd "gping" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end