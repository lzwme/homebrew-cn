class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.5.1.tar.gz"
  sha256 "9a27b913f21e6c0987a9eeb18c051eedd28d8f40f96f4f1b835f67b1d55a1569"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dc7b9bf9102700a328798c347a59ce568fc6561d25202e7e328040002c9fb88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b9131914ea7ea02b5366eee8ac420deb312bf7a7a6c6f40236ed448583f7b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c3ae0db9bf4df473d085b9ab4b52ff66ffd6c381d7f13415f402898b8615a1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7327b16e6cd18afaac5f890532309efdb52399bf170f66e0a7a19da014788085"
    sha256 cellar: :any_skip_relocation, ventura:        "8be09cfd449890ff15c6f9e2491584a862d025ffbce2924cab0623ed8387c268"
    sha256 cellar: :any_skip_relocation, monterey:       "0d8c11b299f23006c699bccc25565e85f5bc59640460511837d6357eb026490d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8762604e21d75d1946ba5e2d5ea3d953d196071709c6632f6c37233c39b6f06c"
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