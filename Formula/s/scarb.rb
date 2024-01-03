class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.4.2.tar.gz"
  sha256 "96ba0a1c49e36a65328a2688e527e98e3a2d58e62991044d2607ed73a594f85c"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d7bf1e28c7cc82583be87c3d61d4f01b7732435c714093657a484ad2f395e91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae12817c3bd76beac90da6d9e3240217e42b38f557a1082e54396b49a6bcb0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f09eb9ee688a072dc5fad7df801a1c811ed54ee4e1b9bf5980da084fe14c44"
    sha256 cellar: :any_skip_relocation, sonoma:         "70ad558fd342a090ae71183aed7bc5c7e658b74f365add2cabb78fc2da9137e6"
    sha256 cellar: :any_skip_relocation, ventura:        "8e79e6b63b089134a2e1ed4d6686ad49915f96142ebf535d5dd204bb2705f34f"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5502a73cff3af9932bca320627664ced1ce92c1c72b39995c58efa4dba59e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2dd42939a7d4b2a286573b0f1106b8806e3ae4e325725c3550f7065ac0746bc"
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