class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.16.3.tar.gz"
  sha256 "987402cff487219de1591abfc6923ebd8f79f596c991a36fc6542e6c330af722"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec65ff4280f72ee3f5ecc94ad5202450b51b2dd1506bb7ae31a5bf7b8fd92329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec65ff4280f72ee3f5ecc94ad5202450b51b2dd1506bb7ae31a5bf7b8fd92329"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec65ff4280f72ee3f5ecc94ad5202450b51b2dd1506bb7ae31a5bf7b8fd92329"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c0521851d9de9ad6e875819fa3e8f126c62aeb51e553e0d1cb5644f81793176"
    sha256 cellar: :any_skip_relocation, ventura:       "8c0521851d9de9ad6e875819fa3e8f126c62aeb51e553e0d1cb5644f81793176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b81242ad8dab3f34fa750279101b69813599d57245b2c525a5940ccc6ee580"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdasdf"
    generate_completions_from_executable(bin"asdf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    assert_match "No plugins installed", shell_output("#{bin}asdf plugin list 2>&1")
  end
end