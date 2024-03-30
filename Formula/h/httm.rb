class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.37.9.tar.gz"
  sha256 "8bda84a7564036722eb83c79b6679b63db7fda94987c05c7f0cac4f037af94a9"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c80cbbe4674c8ae9f6bf329ca0a2e96d9008044c185eea8e8e7e240af36639f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f161554be416c46c0be273f0f6cdbed7e6d4de891e8274e10c64127ce5e8467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad0505a28ab4956fbb94069b60ca70f5e96586695da87ceda40b9b217a6a3f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddde0c0f3edc50e3021bb3baf74832911a16b58a0b81838c7fdd7c786b569089"
    sha256 cellar: :any_skip_relocation, ventura:        "19f0e989f608390771a7ce82f0231ab6ede794fda3ffc45b1748708521f43899"
    sha256 cellar: :any_skip_relocation, monterey:       "39e1ccd1c52f1dd29f79aadc107029f1c1124765c9daf2263cd240b4067e6e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233c792e3dc0a15926fd88d28cc9db3dea68c82f1018399658533f4eacb5fd46"
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