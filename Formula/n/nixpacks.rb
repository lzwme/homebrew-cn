class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.comdocsgetting-started"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.38.0.tar.gz"
  sha256 "071c00fa80b8816029b93618f243b54c215fcb1d7be7e464683d8cbaedc21fa9"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e08bc3c346de0acbfabc11f872c6bef1b44ef50f7422acdf23b64c32c84f2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6784b2b7df3a9bb9ac080a30a744635ad3660abcf63631f44cd6ce79b8859da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "017741349e36620511805fff2f94c2cbe34881c67f4d9f9f7c4827688e744bf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9999ce1819bacc663a9582464ced15049287dccd5d1ff5440b65ce8425952b"
    sha256 cellar: :any_skip_relocation, ventura:       "b1510e3662ebe7c236ca92fc834e08f27263aef2f6d2aefa141e70046947892e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9d592aa1abb4867aa5c417b50095944f3215263896cbe187aa435556134301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9705db815b261b8863a3d745d0bcb86b775cb4f1123bc8869f5f6211d190fcfd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}nixpacks -V").chomp
  end
end