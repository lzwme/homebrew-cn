class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.4.4.tar.gz"
  sha256 "f37605333da2a6483526f871815ab15e2f119c45751d69f37271b639b8e50c17"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207a569ae2565ed16cb9fe84374c1e835295f9ca7addd38b7c3ae94b4d959ebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a551683d89741b0c3b650ddd6092e6658374d55b2732fdad96492e7288408ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9208bb6c7f2fcdf5773d3577e6576bd1fd69909451f22ea5e19a53d517015e4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8b049452130194d6ad6a08b82ea0502f555bb5df996892c3ce9406083aecb08"
    sha256 cellar: :any_skip_relocation, ventura:        "9b963c8c411ec3d7e0f8556034acc87310c06df49e320a1b92ab0546bd8c1979"
    sha256 cellar: :any_skip_relocation, monterey:       "e10a3203cc7b86d78062473fea86616ba3f644e97377c646d9a4a4f1e84a5ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0a5ee45b436ca21e3f3847cc5426bb54e2c5772f78959803c3c7617aa444fb"
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