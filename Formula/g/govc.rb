class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.36.3.tar.gz"
  sha256 "73a4f82e1ee11f96cb9c257a7824ee6c349b0110497329c880e92599f7290b6f"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7518878295a038408bd3c5d822a96deeec5c10b6aa863d684f6386767c83d0a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e23f0d8df03e5126d0c82f959f33f8f44cb3c3eb5550e6e680583170d43f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2834078c712755cd13b60c22ef905b64207028b1344b864de8ec18b951e1bd8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "760284218586bfdb49366ffe9936a93eb31be5a7527838dc944253d8068a192e"
    sha256 cellar: :any_skip_relocation, ventura:        "7b539843bd05228e801f6e8058b8cdcc60bb5d23bd1e7e5c036a50761cb570af"
    sha256 cellar: :any_skip_relocation, monterey:       "2d3759ed0fb51ef0b8e4bb15bbeac4c0e88d33cb4adeafd9f8b110ca5d6445ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1961bcd041e343902cf512d7d7944251f6d4f5a2628aa6bf54ddd852a9f59bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end