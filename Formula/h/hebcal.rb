class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https:github.comhebcalhebcal"
  url "https:github.comhebcalhebcalarchiverefstagsv5.9.1.tar.gz"
  sha256 "9e8be053508020300387ec820cf53ea83a3110a2adc26085a3f2577f83fd801e"
  license "GPL-2.0-or-later"
  head "https:github.comhebcalhebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74fc0ef1119ec3a1a5dd217a143a4db3c7059bfeaed0e641dba45b36f3899f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74fc0ef1119ec3a1a5dd217a143a4db3c7059bfeaed0e641dba45b36f3899f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c74fc0ef1119ec3a1a5dd217a143a4db3c7059bfeaed0e641dba45b36f3899f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "055635a9095aba81c7791c2bdf61dd8f2a11c282ac97063ac9efbf8cd45fca4e"
    sha256 cellar: :any_skip_relocation, ventura:       "055635a9095aba81c7791c2bdf61dd8f2a11c282ac97063ac9efbf8cd45fca4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ce685f3b7dc7077439752d70e410243c14753c0dd3557c9ff6cb8f9556b1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43bb291820a811552e1378ea59e766946619a41471aa4d178d99048599d1710"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}hebcal 01 01 2020").chomp
    assert_equal output, "112020 4th of Tevet, 5780"
  end
end