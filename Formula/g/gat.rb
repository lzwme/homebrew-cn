class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https:github.comkoki-developgat"
  url "https:github.comkoki-developgatarchiverefstagsv0.22.0.tar.gz"
  sha256 "bcb0d45743ff1990fab8304bb677922dce95b16a33b50d7613bfa4f5a9420a30"
  license "MIT"
  head "https:github.comkoki-developgat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e529dc2cbbb100e534380e0b8c842c193013d4db370a5a75c7316f5472aac4f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e529dc2cbbb100e534380e0b8c842c193013d4db370a5a75c7316f5472aac4f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e529dc2cbbb100e534380e0b8c842c193013d4db370a5a75c7316f5472aac4f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec22c1b56b7285bf6080a6c1beca27a9c8b68fd31d2d1c540c0aeed2673c533a"
    sha256 cellar: :any_skip_relocation, ventura:       "ec22c1b56b7285bf6080a6c1beca27a9c8b68fd31d2d1c540c0aeed2673c533a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f97ee9a42dbcf692a2dd6b53e331006c8707d0fc4d44777e86916f81f7ab9d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developgatcmd.version=v#{version}")
  end

  test do
    (testpath"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}gat --version")
  end
end