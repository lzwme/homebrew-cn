class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https:github.comdolmengithub-keygen"
  url "https:github.comdolmengithub-keygenarchiverefstagsv1.400.tar.gz"
  sha256 "fa74544609ed59f5b06938a981a32027edfb1234459854d5a6ce574c22f06052"
  license "GPL-3.0-or-later"
  head "https:github.comdolmengithub-keygen.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce4d2d363e88f82852998fb401ac8bdbcffae2c1028c521bb3e99dc9e1fc598f"
  end

  def install
    bin.install "github-keygen"
  end

  test do
    system bin"github-keygen"
  end
end