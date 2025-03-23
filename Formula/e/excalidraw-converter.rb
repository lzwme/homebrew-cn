class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https:github.comsindrelexcalidraw-converter"
  url "https:github.comsindrelexcalidraw-converterarchiverefstagsv1.4.3.tar.gz"
  sha256 "e1d6d54b44a7fd72b461224ba2ff2db9349c1433877d486ddddf97db6c85350f"
  license "MIT"
  head "https:github.comsindrelexcalidraw-converter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc23c5e752693645418f3c42a98a66579e54c32f8355145e96cc671a36b0516a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc23c5e752693645418f3c42a98a66579e54c32f8355145e96cc671a36b0516a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc23c5e752693645418f3c42a98a66579e54c32f8355145e96cc671a36b0516a"
    sha256 cellar: :any_skip_relocation, sonoma:        "549b36612acb600e5dfdffae4597a2973cb063600ac61f153349c35f1557666a"
    sha256 cellar: :any_skip_relocation, ventura:       "549b36612acb600e5dfdffae4597a2973cb063600ac61f153349c35f1557666a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d69479c2407d3ef1e1773ceab68642d2e5962a9c870589e2ffca50ff49ee6b"
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