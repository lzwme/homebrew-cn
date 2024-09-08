class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https:github.comkitabisamubeng"
  url "https:github.comkitabisamubengarchiverefstagsv0.17.0.tar.gz"
  sha256 "6f5d77939685f6bc3736e3195ea66db5cad25255b5b983a3c3aae5808b1da58e"
  license "Apache-2.0"
  head "https:github.comkitabisamubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb91567c770f49e1605ff1f3dcad246fb9a27f8ad4de17a7d6659006e09d506b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb91567c770f49e1605ff1f3dcad246fb9a27f8ad4de17a7d6659006e09d506b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb91567c770f49e1605ff1f3dcad246fb9a27f8ad4de17a7d6659006e09d506b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e6c930b43dee71742369251d93a025d287888a653950cdbd5a86475e036ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e6c930b43dee71742369251d93a025d287888a653950cdbd5a86475e036ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e6c930b43dee71742369251d93a025d287888a653950cdbd5a86475e036ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707cb68b52318332f51edf453b454ce3561565efabd861c0eca217ac0605fa30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkitabisamubengcommon.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdmubeng"
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}mubeng --version", 1)
  end
end