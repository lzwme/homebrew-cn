class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https:github.comdolmengithub-keygen"
  url "https:github.comdolmengithub-keygenarchiverefstagsv1.401.tar.gz"
  sha256 "0feb346de7927a3bcacadf2122b333041bb7b21b8262230265dc49a2d0f0b7ef"
  license "GPL-3.0-or-later"
  head "https:github.comdolmengithub-keygen.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1aa3cea67da44906e941e9c8119b0e33c7eb70fa38d3e7ff0cfdca61082e00c0"
  end

  uses_from_macos "perl"

  def install
    bin.install "github-keygen"
  end

  test do
    system bin"github-keygen"
  end
end