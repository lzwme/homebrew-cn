class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https:github.comGobidevpfetch-rs"
  url "https:github.comGobidevpfetch-rsarchiverefstagsv2.10.0.tar.gz"
  sha256 "629091dc878916a34a62216540c52562a6b3e0b62fc23504e4b9fe25a5038fa3"
  license "MIT"
  head "https:github.comGobidevpfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e89f7d7320b453cd537a2a4a24757ce1789cc64fa19dd0fcd4258e3f7b1ed6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da851a579c4324630a3bac65cbf2be155246f299e6de7ecdec816739e5373b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9314b463700966aea68c4af9edcdfce44d35df5890bd7529f6b127571241a0e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "189e99571a6ca78d2edd6ea6549d566068f9971ef548a2e3c0ff6d7a8d265b81"
    sha256 cellar: :any_skip_relocation, ventura:        "531affbbb04529b0b599aa5cb2d3db75a679fedb30a5602c389fa092a7ef0ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "da98eb385a78a15d4ba060cc1450b4d0fce09bbc4b0c5a32ecd4a00647a8d204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e3d51d9acfba84f5ed879f8fc30f25292d025e66a321c2de575ae82e7d6d129"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}pfetch")
  end
end