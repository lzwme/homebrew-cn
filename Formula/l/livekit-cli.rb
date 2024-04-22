class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv1.4.2.tar.gz"
  sha256 "a701d3099059a84c74707791ac258e836e34d513765a69613cdec69e397dc81e"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d641b49c956977dcc421fc0788ee4e833864e54fe3d82b491f4be73e04ffa45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16b8c50cdda48824ccff8e75c32f179883889d16031c1231a89604ca9e542c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eab534b18d6ba99927a5a063411512b9abfeeb41a48d71d758395347f208358"
    sha256 cellar: :any_skip_relocation, sonoma:         "097e04d077a8f9e37fb3eab5979a3343c84ff8775af5416333df19773bf6e051"
    sha256 cellar: :any_skip_relocation, ventura:        "747d278c8624c4f64c8c1a4ead5b7ad440845ed15ad99854638bb6e3cea28042"
    sha256 cellar: :any_skip_relocation, monterey:       "499372b3109a52b46765f0b7c34d15040a8339230b4db107fa7aed5e4ad7a0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bfa9259cdaf32be55ba79b6cb19e5e8901c11dc068d1cd69fd6868c42c0480c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, ".cmdlivekit-cli"
  end

  test do
    output = shell_output("#{bin}livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}livekit-cli --version")
  end
end