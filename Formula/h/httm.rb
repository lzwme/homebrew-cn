class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.40.2.tar.gz"
  sha256 "1b784f76db097680dc79d312a41a16fa13dcf145fb72f29d5b6b135f6a0cb3da"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44ded2de57765f50c1f6022e9af8239e24fb55893fa06216d6ae36afa763088c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c6366f88bad1066afdb46adc5a1168d5f4cc1da72ee919514b75bf9966e5c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "557f24cecead8d6fd8d631f833a3282ba445e39714a4a02fc6d095fd1121c608"
    sha256 cellar: :any_skip_relocation, sonoma:         "708684fe390592cd9fa3ba53c18a625ab35ebbfa875b7c041151fee641b09d53"
    sha256 cellar: :any_skip_relocation, ventura:        "a78dcf99e1c0265b866d8a11f5d603cbd4fd0dc0c8633ada721d5ed06b375f45"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffbfb9246d02212d03cc02fa0a1e136a793d264132351ad4d35b17cae417220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d039e7b9d50298a56ddfcf7695892f2dc9c19463380e9297b4134d4133d512"
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
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end