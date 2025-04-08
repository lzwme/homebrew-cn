class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.7.tar.gz"
  sha256 "9340b2ee629c1841f13c7ea022ec52236d8883636e0e277c614962e2ac158f57"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15bb64f63a98612976f5b44caf82a55072b69b257e3edaab7371d1dbac0082bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58ece885ff8c3e191b49a26cfbdb83d59bd968d565486f66e81dd7767bfbdec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c0bb5833ded4da1584de9671d63a4668b685630d9538524291f6f21eac14360"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4750bc86e2650ea33536e66de8b87d1d3d58e4853945bbe0d7b2204d32b18a"
    sha256 cellar: :any_skip_relocation, ventura:       "4810f8b03fee0c9bd0b4ac4c5edf4a881c1a0ab0bf5992780d35f0c3f555f04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7198bbc489e1aac01961c69b91b1a41d694ff15f1c7b5298a4c67d6a7b3122f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f10f7e616ab680d15b26dc7c0cec620b600bd02e1548e0326e4641df84d4e7"
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