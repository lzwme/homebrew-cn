class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.3.tar.gz"
  sha256 "826c7b51b680c2e43fb09cf7c5b8a51d8f7a1c2d1fd49459fadff4a48c47cd00"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01729b2b6d8d138128b4da697b42a2f1ae5d2ffa5e909176a8a65c9f7410723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a42ef8196ef0bc8dfcfcc6f48c1f155f08911f03522ce4cb5b2d0ad4b043c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "441f78141cd63ad4f39eb2b96555eddcce7adb926ecada64311f7885f1f63484"
    sha256 cellar: :any_skip_relocation, sonoma:        "9698795e1f38be3531811688c86ef4c98a7d7d1c38bfe64a4ea6389a7a33a633"
    sha256 cellar: :any_skip_relocation, ventura:       "eca6e6de41c29d6e54710004b46109253f4511b8ba4963b00d2a81a396de1030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25283d26c37df2322f0319cfb6e0ff0701003fce57da96bf6279000055bf766"
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