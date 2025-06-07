class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.48.3.tar.gz"
  sha256 "733536906d37f4608b6a4ef2924cc983b738926a36e5d812fc17fb05a83630b6"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7d8ba1f75923da534c34fb5a8b5e6705c02a61247137dfb9aa1d2e8cc401e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c2e0bdbbd62af60195f9204056b9c0a3ea60897f113ddf09ce45c3e9b373233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b448af26ac3b4a0263be671d9188fb62df80a696947c4e202d6ef2e430fbd78b"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a81bf32c39ec213aad0aaefb5878f1fbe16ea7e3e4d0f0a08e78b802ade1db"
    sha256 cellar: :any_skip_relocation, ventura:       "c0ffea9c3b7f78338196febbebd6d2ce49f6955f5a8a4d58bd7eefe8442b25c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b8fad62705b0301563bb674e278bfe9b6373bd43267fc51b0c095970b9d29d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693c11f2c92f75c79d7f06f55f9e9164b49314b391aa9ebdcc9a6c8943a2413b"
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