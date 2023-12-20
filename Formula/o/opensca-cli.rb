class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https:opensca.xmirror.cn"
  url "https:github.comXmirrorSecurityOpenSCA-cliarchiverefstagsv3.0.1.tar.gz"
  sha256 "f911bdd54875a5b39e139cc9e944c33d3a9365af41c2f6b9f536b6102422e3f9"
  license "Apache-2.0"
  head "https:github.comXmirrorSecurityOpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dff68e5e1365fc7aaebaee4e3cd009bd80eb84088e1c10c42e35f27d72eee9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e85ab5a05c1c028c0b826200458ef846223b313ea9b4fe6487506eb0c73a900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e701e6e88a49befdb60d8cbe45980fd42638c3660a311fe2ff4df6936fd8b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5178bebf6b3b51b987a1c676244f5ee8a03decd694e2f3b91fbb4d0f7532e331"
    sha256 cellar: :any_skip_relocation, ventura:        "345373b6b9a9623fd983d6d4bd981260efe0b4e3f9ffdf155b339cdf513073f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1651de15ea122e0952da504f101f66d01cc7a65ae7b113005dbef7688bae47ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7427a7824b4470f321d7576d40fb238d960091881814c33d747ffc8eff69944"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin"opensca-cli", "-path", testpath
    assert_predicate testpath"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin"opensca-cli -version")
  end
end