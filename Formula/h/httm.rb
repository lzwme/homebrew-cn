class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.34.2.tar.gz"
  sha256 "bffb7b5ae3402aa286875f8092353ca1661c415a98f617f96cda4f77141a981f"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3aec1c3485b2652b134118a6a78d7e62d13bd92f26f9577c90372a29f8b24c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c35d5fd9ae97a55b6b865ea5db78e075e181ceaac116380090df27a6289b128a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5653282adaf4be5a8e6649063a0bea476c252136c18596416b428fc705886a2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a312035d3f71e2a03f711a68956f3ca2b9580c62d81eafbe0d771cd4a97bd1d"
    sha256 cellar: :any_skip_relocation, ventura:        "5f85d712b108a78fb5b0929e5b2675e364172139178d425a0b96f6b8551d5ffb"
    sha256 cellar: :any_skip_relocation, monterey:       "07a6aea0d425e7f1992de113a2c20fa0dc5ea93a9b4586513abe9e9b9611b032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ec4d2f0290f623c8f283974d74326d5184f5f2da58edc06b7fe2e41cf4e61c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

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