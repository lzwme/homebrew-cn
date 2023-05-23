class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://ghproxy.com/https://github.com/orf/gping/archive/gping-v1.11.0.tar.gz"
  sha256 "df32aa9d435fa724c1fefe00e32d3f53c7e8d29c11d63031b97c9cd82c0afc26"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b166d5f0d764b79a6136d8c54d443c162a857ec3a031a2ee802518165ca4a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b959bc9d108b186291c985440fbcadbb758c64517b92ee942a12d0a8088226b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b7f362335b79b525b35b15174b1c1fece569ff41abb0285a8dfbd49c253684e"
    sha256 cellar: :any_skip_relocation, ventura:        "0755a12b6e9dee632034681519be2d4d7221c0fb2ae60c4d1f4db1772bedc328"
    sha256 cellar: :any_skip_relocation, monterey:       "28945ebebf8604ed7f64383a8ad61ee7836096874efa83d2d66042f693eea9af"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cfcb5e27992ed54794dbbb2e635046058918999c65ad66dd6ea8a561daa8013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7120dbb9c38f4be98c8a6846c86b4aa34a765e71d9532cf0e8c96825892deca"
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