class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.4.4.tar.gz"
  sha256 "ff7dc24e0bb01120270e7fa455ec6a06b64a3918abeaa7019bcad53d9d3fba3e"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a11b511959bebc98bd23d60ec2ed92c6c84b25a6675aa494447c8aebc71eb5b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16567a5920ce99166fab341fd9184d0ad534bd78bab3fdff3b81fe81018f6b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b7319d0b01a38a262f670245cb54485c5aaf2db978bf0f9b7b3ad68e7740af0"
    sha256 cellar: :any_skip_relocation, sonoma:         "683719089e8721edd3055373d277471186f96ffe68c6470f6845d842ec4bd6d9"
    sha256 cellar: :any_skip_relocation, ventura:        "4b710f8534ca24244385f0bc43e7d6a1e096393450ed206c64cab526ec1c5a27"
    sha256 cellar: :any_skip_relocation, monterey:       "1aae04a6234334e145474aa5e58d981c8229b6f7d47843189c48aa94f17ac562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3367690b3b1e237840dbc63ce6dab80ccbb605b9a635a7185eaee0278fcffcc1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scarb")
  end

  test do
    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system "#{bin}scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
  end
end