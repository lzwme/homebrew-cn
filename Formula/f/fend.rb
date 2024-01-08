class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https:printfn.github.iofend"
  url "https:github.comprintfnfendarchiverefstagsv1.4.1.tar.gz"
  sha256 "eb40e376e1da00055112edc583e86ac3913536b35f2f7265de55dca52319a4e4"
  license "GPL-3.0-or-later"
  head "https:github.comprintfnfend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f03a19306e186c74e2ea5bd2a4fe93a3ebf3675bcc2529757549e705127eae24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75ab6dcd7e1d29f1b020c54b0e0a71ac1df0583a228e6f163dc674daa964ab3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4377f8194ee9b3309e9c36158fefac4d0d92b303b5fdede6f7f3a0a939b5599"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d92f36cdf488a8b4b5102453415771efc810a855b76a472050af0930de52dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "de478d07d7a03859a121524ac18274f16c5fce7049887192636d859a53b9d780"
    sha256 cellar: :any_skip_relocation, monterey:       "673b2292e72f10befcb5f769b4d2c01c63c0704eb650c2a4c14f9904289c894e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6672364eeb43d5593711fe41be591b9cdadf96f94202f8ef6ffbf7418f60685"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system ".documentationbuild.sh"
    man1.install "documentationfend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}fend 1 km to m").strip
  end
end