class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.36.0.tar.gz"
  sha256 "c65415cdf808df73cfe31b451b3d941bff2a35daf938e77c5904f27b99867f76"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "775b3300768e7d2249ec5f8042a98908244db0d1b06ff37cb1163aa67011bb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b0779cfb1fa8a38706cc7cc9b4e4099d369ac3d678a6ce8271dc036c914279c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d705c92e6752dfee7278f40d0721b88d347972e52da0bee2b14ecb6988929f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "99a0d2f87575712a8e08a025371bf1ab6e60bcc270d2985d8623735ef0b32574"
    sha256 cellar: :any_skip_relocation, ventura:        "03695b1e49248baf18e88d58ba7ccd4b9f0ca79f74770a486178aa9b63528b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "91ca732f2ff4bf567dd1c032991181764f543b8bb66a2e5c2d1fbec1aa237e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52e0dd21f18a890901c026bc7096760df2a35555adf511997cef7a3a0f32383"
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