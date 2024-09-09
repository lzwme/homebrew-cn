class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.4.6.tar.gz"
  sha256 "ac4321f30fd7b5fbb9a4fc6e21242f7de739310c0ba36cc9a73f1791efa5ee22"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a139c382cd22a128f22de230c285bfd8f2191412de762cb20bb0f7717707547"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2322d27a12e8456a257d4fb8dd2956f1927ba83faf56474735cbc3337bffe6e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813fd47412499ae6c64bb82a62eb92f87b7728d75af8e847917141b73fd85826"
    sha256 cellar: :any_skip_relocation, sonoma:         "36ef0aed5469f91c3b4610f068a60b90ba3166b506ecda7b3a9fc661e19ed03a"
    sha256 cellar: :any_skip_relocation, ventura:        "5f90e6fb795d78bae5ea5521e55ef9a598baffef937cf3cf18613a19da6d77ff"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a97a482ce4ed1815e6220cc8e2ee22344df059a3f72637eb8b21485e810db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dd50e60b67e6b33c0d804bf308ac63922259ad744a6295719c5e936407945e"
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