class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.6",
      revision: "c3a33a522764a6900194538474009264cce4eea9"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d1a6fb0a83db16fe8a4cfea4239935374a2a201560967b051def21a323ae72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8bfd435c3a3b3499ef66216dd5f40b03b3b9cdb75341da75b85ed03d73059b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f0a5372572434a64d15eddda6aac6e63e711858a9e67e77eb14176eb93e970e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3be3e9ac0f756151b27dc436aeda2ec42617f0364b9a541ab91b953414f27ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "877db0f809b60a07f1e4eaa4aa1b3743c3097d66f40e281b518f386b8ce80804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a2282ce7047870b7b8daada70c90e90697b0280455dc67271f47888fbdcbace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e08d7f472937fb40aaa4b89e43967338dae8910faaaa1bc889c860723811d82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end