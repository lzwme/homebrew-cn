class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.36.3.tar.gz"
  sha256 "10b305a0b1672d20e8e0c41d9ee5aeb08b3b1f5aeacef6be0a34815f8e65deb0"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e614daed8900f4610a5bafcedb8ba13c7cc682635157e0aff17f95d8658aea60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f02fe945f9029e9c8513f49fedf82596d211154dfeb4b95ae380ab51efd3d427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1e6fce506314226cae5bb68ae061d8361f66a54a8a807082864b58a32545b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b40ee6b537fc52174e835c0ac40c7c7708bdcc8c7a9e6a654e79aabc14502d"
    sha256 cellar: :any_skip_relocation, ventura:        "c50ef12d1dcf157bcc40f2dd3bdeb2ab08f99db1ef327aac3dd6bc645c690d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "e071fc5140eeb59c33d9f76ba650b0cf7eace929cc8c94c0457ae5ea58f83ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960d03ed7abd62e5cb2710d83aec32c36ed41f631fed1029aca594c2fd808296"
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