class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.44.0.tar.gz"
  sha256 "91e9940530ca5cd6a440cb6e6d6f25a0243106c9dfdb9764a857985cb7ba61fb"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f048e3c83a6c2c7f145694c66368101f47a0f040871018a31b6a5057ef10f670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2fefbb3cb12d293a78053b44549d3ae4be6c6e9f0a88ebaf578b5c2ccb41751"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "945adbb233446290561ecd7b1def5094f359a4928a73e3c5d0f1d4c9a385b59c"
    sha256 cellar: :any_skip_relocation, sonoma:        "004b953e4a316ead4632ae910792452c49e8f2f701c314c2884cb145f50744a3"
    sha256 cellar: :any_skip_relocation, ventura:       "75bc5fbc442f807554a5b2bb6763dfc04e57fe479a1daa4275aa3887d81c518e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55088420d61de14fcd23d7eda512a22ab5fe6bda238217e872050f4a2354d04a"
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