class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.4.tar.gz"
  sha256 "daef3f4f3619b07038a445bc03ddd801ab9e3a6aed1e2be0719eb3403906afa9"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc8fbaf5897fe35d6c835be054a3d7bf024f548f1f5ceb86595cb600080342e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "839b449e460fc1aa77b948f88b9c82ac8f1c58be30ea8f34a0a18e9c1f5e6c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f9d247fb5a88ec5f3ba83e6aa06147633787440cf96d891bbda15dd85050f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf234aa2295f43730906056e9ad614d2668cd3875603c23396ebf245e4f0ef6"
    sha256 cellar: :any_skip_relocation, ventura:       "c1a4e38a637ed27c003a8c46db4431563f8ce931862bb24a2b0c352f33bcccf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0921047a5328f60c569f93d8f632f17e083ce4023dba5e0e91b054db803e047"
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