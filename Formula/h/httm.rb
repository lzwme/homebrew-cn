class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.41.3.tar.gz"
  sha256 "3cc1f5bfa790def9da6f5cd9f5da4405dd306c40c31b2b2b98451fffe1f81c8f"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb3496e8f50d1400c3ec678963282e2314bb3f8cc4b3c78043f2ff4e4fdd99a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7025d480b142b23adec914dbcd0df107b59eec18dfa250664ab00d0f11a698f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddab7c256ae2fcf765534f948e57f392fcba41f1077a5e8b85a29da3c2333d34"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdcec60fd6a7431a6680601cc9e2c1d789e179cd111f58a66a1abbc1b9819044"
    sha256 cellar: :any_skip_relocation, ventura:        "3f62d0fe71c54cc655872d76998d32a73795987dfc434949fff35c09dfc24b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce8e0df215be39584ff7821bf4c3a4732e2635b9eb5e3955ab22a1fb0604e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95462787c83e32f7082c3cb19df382d6d1c1a3e857e3bfe87177bd960e971559"
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