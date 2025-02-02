class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.45.6.tar.gz"
  sha256 "ff5d64f8cedee2a1a7fcddfe122ba75ef9322ce53ea1312a17ecdf8b2f17c996"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a11fc65a224926738ccb7fcd232f91954e75270a25a8fa64c8e936deccb4f312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f0bc36ffcda5be3758bc426a58f1a36ca7e9c177e5eaae21fdfefdc78c21e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "556b89a55ccdfbce5225ad65b5640255f8205ded986e40aab50450c73d582b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "570202422f3c7707839baecd678bdd9e0cbb2ddbe316483269384999000bd86f"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb7795f25e350aaac74b02a2cc3baf3568c3fbf1f7b8dcbeaad6c0d2d41079d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7dc298ccf696ac957351004df9bc6c39d093a30f5e1930a15adcfc7a794d6c"
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