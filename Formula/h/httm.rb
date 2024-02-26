class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.36.4.tar.gz"
  sha256 "e2117da560af5f56b0392122365a919ce9e0459ce31f2da4ce5f5dd141fc8b26"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b598b5b23f9d45717f9be4c2175b226eb25f528cec21dd5894985796f77255cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "109df592e4dc9558e31243b352235fb03fe224191968514d01c25322a503e9ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fed8ff42583c7f4d056b49c4a6ac7cba10488137a24e5249049d09b8e983859"
    sha256 cellar: :any_skip_relocation, sonoma:         "26d59651bc9afdf7f879c1776146c74291066dc4077d95e89cfb936372d24bf8"
    sha256 cellar: :any_skip_relocation, ventura:        "221648cf1ffbf53513cce7750817a49f91827dbfb32bab3bd5dbe77729f679f6"
    sha256 cellar: :any_skip_relocation, monterey:       "4adbe8f049102459cd8a2cb24b971cb0f5a7f6ebc76e230f30e2d932813a76d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57af1575d34c3068c7a0d560704966efb9bcd7dcdc241725a9b2b3a788f8a45b"
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