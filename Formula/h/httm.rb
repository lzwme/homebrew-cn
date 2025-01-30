class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.45.4.tar.gz"
  sha256 "ff130208f7d16798b4b4bf07e692299b11017df22de89307a9a42b8059db15cc"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eacd69fcbb7f9ae7d0c4358a235d55ef61d8513680f645509d8c3b1261cf96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f8b30f12a446a233af2a56d2781337dd87f3742998545c61e7a7028b7415243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12648b01e3940d7edf89290d391a7a372d7b953a5936a16ad73fee0b431045a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef45f6d6351fa1471073e54c2d407ae9aa3eac0676a8574e14949d36daf92c5"
    sha256 cellar: :any_skip_relocation, ventura:       "2c5dd742b9edd0348006f0d6a2a79bc6ec38d8945d003366c014d921d2896a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e010c7c940392f6c72eea5693410ae7520fc064d8f7a698a9cfc488e007f4d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scriptsounce.bash" => "ounce"
    bin.install "scriptsbowie.bash" => "bowie"
    bin.install "scriptsnicotine.bash" => "nicotine"
    bin.install "scriptsequine.bash" => "equine"
  end

  test do
    touch testpath"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end