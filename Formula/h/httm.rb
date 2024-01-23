class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.35.2.tar.gz"
  sha256 "528c99fe37ca8d5303ff78adf4417bd2c0ebd32fd2b2c015f32b5dfcd0afc4a7"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfb543caac29d057dcd54095cde9612b7ac006756641ff120492352fc16af4cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1611ff808044c679c13445a824b1f620331c497be1eb4e43056a2b74ba7473b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c92e06ab030ae97a7e4da1bb42abf84e0cb37ce72cfd8a94137b4246ce336c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fad26c75ba29d454da0d0cd044ba29d1482c08d98df37f3ca32c3eaa6e518244"
    sha256 cellar: :any_skip_relocation, ventura:        "627372d7b1a569dcf3f8a1adc1bab5b565aaad1b4549ff71589b86d20150d714"
    sha256 cellar: :any_skip_relocation, monterey:       "ee386cafb8429347bdf12ceed5957865542459abeed9bc3155f7ce15f7f1e7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "778be655ac7b0e8fc04e594ea5781dff31ba75815b42c27cff2ecc3b1d413080"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

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