class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https:github.comsindrelexcalidraw-converter"
  url "https:github.comsindrelexcalidraw-converterarchiverefstagsv1.4.4.tar.gz"
  sha256 "15f39bfc2edf87842e253bd6f83d780a9405d17f87efd19f61057b097003a9e4"
  license "MIT"
  head "https:github.comsindrelexcalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "160c38d14d4574c96ac50927d2931af0adb3fa9f58b566424cfc65896d6f4b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160c38d14d4574c96ac50927d2931af0adb3fa9f58b566424cfc65896d6f4b4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "160c38d14d4574c96ac50927d2931af0adb3fa9f58b566424cfc65896d6f4b4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ac2476278ae3387793a54e0136dcf96df4ce2ef9a9d69f484cd2e63ab58343"
    sha256 cellar: :any_skip_relocation, ventura:       "94ac2476278ae3387793a54e0136dcf96df4ce2ef9a9d69f484cd2e63ab58343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c2d4ede88455a857d4e80502040afacefc8ae889b76099bcae2c97ee85f622"
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