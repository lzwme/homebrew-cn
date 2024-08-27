class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https:github.comedoardotttcsprecon"
  url "https:github.comedoardotttcspreconarchiverefstagsv0.3.1.tar.gz"
  sha256 "886c7628e63e57c93ca1e85b7bd499f629d43e744d91ec1c79e999fa2ec13f13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9c2a2612d20887802a3d6dd383ff11787d1ffaa379716155ab90e0886b4a7b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c2a2612d20887802a3d6dd383ff11787d1ffaa379716155ab90e0886b4a7b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c2a2612d20887802a3d6dd383ff11787d1ffaa379716155ab90e0886b4a7b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "30f09a86cf552d6db79107b5e9f4931bb34a902f6a928f3d452b273aa4d30193"
    sha256 cellar: :any_skip_relocation, ventura:        "30f09a86cf552d6db79107b5e9f4931bb34a902f6a928f3d452b273aa4d30193"
    sha256 cellar: :any_skip_relocation, monterey:       "30f09a86cf552d6db79107b5e9f4931bb34a902f6a928f3d452b273aa4d30193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "409e92272f12e57d57ff537407f5746ed8d42e5b7b5b72135b91e6b42eec8d0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcsprecon"
  end

  test do
    output = shell_output("#{bin}csprecon -u https:brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end