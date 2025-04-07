class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https:github.comsindrelexcalidraw-converter"
  url "https:github.comsindrelexcalidraw-converterarchiverefstagsv1.4.5.tar.gz"
  sha256 "6b8a457b11a1946627de01f948adf1465b179447aaa7b4435dcbd492f4c15afa"
  license "MIT"
  head "https:github.comsindrelexcalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "232799c1eace60fbb1b564d9776886298787f41cd52a2150a58f0317edca51e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232799c1eace60fbb1b564d9776886298787f41cd52a2150a58f0317edca51e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "232799c1eace60fbb1b564d9776886298787f41cd52a2150a58f0317edca51e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7aa2c9c73b93580c2130fe265b71560226e81851cc52af89afab925e68e487f7"
    sha256 cellar: :any_skip_relocation, ventura:       "7aa2c9c73b93580c2130fe265b71560226e81851cc52af89afab925e68e487f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492b6c807da8de021656772482d817deefac81c1b859d3fd919342b1c26dc134"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bin.install_symlink "excalidraw-converter" => "exconv"
  end

  test do
    resource "test_input.excalidraw" do
      url "https:raw.githubusercontent.comsindrelexcalidraw-converterrefstagsv1.4.3testdatatest_input.excalidraw"
      sha256 "46fd108ab73f6ba70610cb2a79326e453246d58399b65ffc95e0de41dd2f12e8"
    end

    resource("test_input.excalidraw").stage testpath
    system bin"excalidraw-converter", "gliffy", "-i", testpath"test_input.excalidraw", "-o",
testpath"test_output.gliffy"
    assert_path_exists testpath"test_output.gliffy"
    system bin"exconv", "version"
  end
end