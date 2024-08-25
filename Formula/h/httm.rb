class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.42.2.tar.gz"
  sha256 "65f03bf6896e06460a89c79c627a63d8d9bb3a145b242861a41987fb7a3ff3c7"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dca67286dd6770727f313c6a69e3c543701bb654bdf532c5563c1bcab0b62af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d8f1dc0f8f8c94f6484bf3baf301cb2fe98ebd40196ac5fc127d455f1d29d71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005625eba0458f62e94b896ea7a03c6beff8d33307b120af31502977bc86343e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8081c763d8ffb1e4530245cf6c228d5d51568d025bb956b864013ea706e17465"
    sha256 cellar: :any_skip_relocation, ventura:        "3e16dee766acd8350c70e40f3c2beac361f6ddde279070f6994faf224155dd75"
    sha256 cellar: :any_skip_relocation, monterey:       "90fc9ba5e3a86853cb4cbd2855d556fd3cc32dc1ca8d16f463a18dab87fba832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "271c5784191c9f34dcf0ff5cf0c0c993700d16ba1493d8729868a302f5f861ee"
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