class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.6.tar.gz"
  sha256 "d4a2b4bf5981fa10626243f5824c20a38813d57bbd05f2a81f5ec6f6050bb744"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d41cc159e143222e3229a3bf7ab819184c97939d70cb0fba99da6de7cc20a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2662c290b99075bc64495153a3455896df1469c9bf682b153ba7869fe8395717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "905024b6e664056975e32105b03b683d21b40b4ee6c279ddc35590233a71de38"
    sha256 cellar: :any_skip_relocation, sonoma:        "d008aa8e0f6c337087386946f1ebd46cfd873ef8466539148bc2165396358c0a"
    sha256 cellar: :any_skip_relocation, ventura:       "315513d186e5430e1548e186900fa1c974ace921ed8969913d9612f88297b054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae456baef543b8f1df23df4c9e107cdb71361918dc2b81407df801812b103e4b"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgopeed"
  end

  test do
    output = shell_output("#{bin}gopeed https:example.com")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath"example.com").read
  end
end