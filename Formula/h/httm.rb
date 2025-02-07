class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.0.tar.gz"
  sha256 "2c1df432baf06a6689b137daeb7c9b9ba85c0e47fcc8d5e67f7110b855fbe90b"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ae90e2bb28f10d59c294a7155864dfb4cabefecd8e0168db57f610352d86d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003707b4eb9a1028998202cf70ec6bf0ff552084ddef3f254bc822d46910ad08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a5bdff3daf8dd2287c24e0641ccf86f3f3cbcabb604739a7a938d369545e905"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f45380687b78d9b14320e461424649d0e9226f48ee99215b0ab4d70054463c3"
    sha256 cellar: :any_skip_relocation, ventura:       "423de6e3acf6f3af4ab7c5cee59a473689a5db7b4036e6ff59ba1e8264de0c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd061ff30c1f9f0f99cd2b60c99dd5c3ea0a32911721ffea5f8a691357c50969"
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