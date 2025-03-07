class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.46.5.tar.gz"
  sha256 "ceeba536cf73084f4810315ce5fe498c1f77d2444463aa987c79d74eac9d1acc"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263a4fc557fd151b5a68588d4a714a32e0ff2945bc77dd95988a059408092485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8644f2c963b4be97ebe9befe413027f3794ef28828542a013e54a7970762b903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a5752259203013e1f4f418cc5b7f67822c473f2e1ab104871e473d30eef65cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c866ef5b10168d6fdb30a58f46f2e5bdd997328dd4bf71821b52ed0ae5446f86"
    sha256 cellar: :any_skip_relocation, ventura:       "c7fdc8181383129fa65bcd7426fd840e1acd2f6973ddb486e60d51b48f5bbe14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb2f2fb447d58cf81557828d0fbaa78fa6b589adc4653a0008ec3f140aebc0e"
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