class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.34.3.tar.gz"
  sha256 "f12afdbb3deca98e9bd87e1ff696ee4b0866bb4816b1701e67528cd74f9e5cae"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91b8b8289a860659aa561a523c67a06ff5f2d9319267b550836becf4ee933a68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eaeaf4dd72fc6cbc06426b38b087a61aa3c5e73064b9c6b4934ca8c2f03f076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3d38b801c432fa5f618c412acc66a3a1c4d6d7b64a5066fd06f2e762cdf692"
    sha256 cellar: :any_skip_relocation, sonoma:         "c19b9d18d53d442d5d6ccaa77012c046da5321f23918fcde2d79e3421a9ebe97"
    sha256 cellar: :any_skip_relocation, ventura:        "868869845f1be1d02bd18df54dd3416041cac1943f49fad731a8c6e7d627e11b"
    sha256 cellar: :any_skip_relocation, monterey:       "05ba6b110839e5f80982b6ae1423d0be83117827eaf7713cbb54506a7cea987d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d46f21380947f7d80b5f780005b2e2fafdf741bc141d946befe40ad0ee1c94fb"
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