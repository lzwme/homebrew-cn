class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https:convox.com"
  url "https:github.comconvoxconvoxarchiverefstags3.18.7.tar.gz"
  sha256 "59569e3d727405ab6b5c4ecf7f32a879a12e3e7b26aa87804018dccaf3244a89"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76555d6e7a3ace5eec0a3c17ce0fefe5216e596d1084010cbabb63fd55f14273"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f314f0918e8a660faff93c2f872a72266bb57398021e9ecab93065a4d093c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5212dea38c551073e648ddd63e9757d6d1103b9e75005c0330863989486c2380"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a45bb36adda24c3cb26b1ea758b2bbc33d917669533bbf6831557a5e63241a"
    sha256 cellar: :any_skip_relocation, ventura:        "96051ad096eda4aba7a744230d383fdd8d09a4daaf7d01a27eeabab393853774"
    sha256 cellar: :any_skip_relocation, monterey:       "cbed5d26fa01a7cd457040ed396057fc2c7e60df971ff2a49a4f3bc2d15eab1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc660d7ae1d31db13c0cc2d71e52236e4b49020a1effcc2d8771d382e3d686c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), ".cmdconvox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}convox login -t invalid localhost 2>&1", 1)
  end
end