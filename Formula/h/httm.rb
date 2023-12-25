class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFSbtrfs"
  homepage "https:github.comkimono-koanshttm"
  url "https:github.comkimono-koanshttmarchiverefstags0.33.4.tar.gz"
  sha256 "92e2b019a085663fba2b834d3b93b9ecbba5d3a81c7370ed1be3feead2904ed9"
  license "MPL-2.0"
  head "https:github.comkimono-koanshttm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1501fd1b3e20530c9e52a63fd28926dd8c6f8d23075f5db36acc8fd6ae599eb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dda9878fa63179f04a9a0076337b445a47cc8611afbc849b8665325b9c5dd331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18f4a3a3c4e821e0bb37416da8c23132146650d4d23c597c5f75aa7d72fee36"
    sha256 cellar: :any_skip_relocation, sonoma:         "c60441e6cff13f65e68067c8c74884ad757d955e184415ba4d311c2810427b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "564ad46267e0e4c9e5178817a0ab1226a8f433b408f9ddcf25218a14ec7fc847"
    sha256 cellar: :any_skip_relocation, monterey:       "3055e1ea64e028c8ae73d6bff25f171260a10ccb34cd71f8cf3c606d8428dd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c7a401326853d722320b62fb8a3369adafa4df5e5a60943b1acf318ef69f2e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}httm #{testpath}foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}httm --version").strip
  end
end