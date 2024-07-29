class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.5.tar.gz"
  sha256 "b67ed6356897964f9b4483f6384ac5e209b4c71e3baf9db4f9ccbf9002dc08dd"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa65ec9396632b378ac30cc96ce679d49b50d21c2e217d7a346a89101b6dd777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8b953277f1784f13a35f05427cdce7ad63713e97d79a55fdcd6c1de7a5e4b9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee500e749dc18429ad4fa2977bf9eef8e5062ac68d6ca11c1a1b7d0818a39a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3369e2fd234e5de88c2d7595e4406f5d3249575d3a3c212e2bacb5a04413d44"
    sha256 cellar: :any_skip_relocation, ventura:        "89461ed9bc355a86b303199c36a72585248915d60e78b92596e3d57922cbfc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "345b869bd23df023e5c8123670a2058cb843e33304678b86260b452ce7f90831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6c211f233127d0beb7b2721227c01228aec2b554ebaa3d03f729cd9101a1623"
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
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end