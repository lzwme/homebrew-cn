class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.6.tar.gz"
  sha256 "54b1d530276f441afdb5fe989f31efbb54eca934c71a808c0627b60b6b5c6a95"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc72a9f85a92d2fd33b410890e58d4338b8f4d65ccc380d68ec1637d59e13a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f0f191d1b87ff861e7a55ee78e123d96a10e6eaade40f20ad44ba2822edb76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a54db326ecbeed84c3553284e5f2b2871695a631a8d68a93e0312b14ce72f3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ce51de84a877b925fa2c2c53f8176a653adfbaea4ad9ec732279c9651c273a"
    sha256 cellar: :any_skip_relocation, ventura:       "78861d780e972d23161c93e3b2718ffee87b7e1e79d428511501c5b292b97476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c066445f426fe60e7a5178de80fb1c2b7c3a4a372e3d3df497b65720a820937"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end