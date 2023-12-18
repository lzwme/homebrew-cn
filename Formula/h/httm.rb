class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.33.0.tar.gz"
  sha256 "0f5a59a67e3088f5adffa6a189da7729facaf755e25b08f6dc881e701c7839da"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a86f449959d34e1024dd13ddf97c58b28dbb7369774f9cb9e0b05c0f270a306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d413237ca1c9ab1cb9b081bb710a209eb8a5419a77fa405dafd7c464fc5f399f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f91012ee6858ffb6c6b82663cfe1de0687a05f3b1f4430f921670589d2fb1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a906338048825ac3a624ccfc02355e5de2e751e625bc2df8847a6d7fd90c619f"
    sha256 cellar: :any_skip_relocation, ventura:        "ae34a1c6aedb9b9e8bf7cf0651d1cd348368a738cc72aa6b1a8b04e85ad47929"
    sha256 cellar: :any_skip_relocation, monterey:       "52d1929d9985b43bfb3bc2748b689a77846702967c914367d036e99be7d2a5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea77060e7f21227e930667c92d3a3eed0f14c52410b5b549922fdd630d0ad651"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end