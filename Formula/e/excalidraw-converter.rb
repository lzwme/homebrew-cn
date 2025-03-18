class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https:github.comsindrelexcalidraw-converter"
  url "https:github.comsindrelexcalidraw-converterarchiverefstagsv1.4.3.tar.gz"
  sha256 "e1d6d54b44a7fd72b461224ba2ff2db9349c1433877d486ddddf97db6c85350f"
  license "MIT"
  head "https:github.comsindrelexcalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "763dc4bb5ee943e4410d0e62ce974df086fb30c9880aad434931d5ec7ee315b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763dc4bb5ee943e4410d0e62ce974df086fb30c9880aad434931d5ec7ee315b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "763dc4bb5ee943e4410d0e62ce974df086fb30c9880aad434931d5ec7ee315b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "922fa0d2076dab8305a8b3272be219dca5b5df39f1fe1fac65399406bfe000bb"
    sha256 cellar: :any_skip_relocation, ventura:       "922fa0d2076dab8305a8b3272be219dca5b5df39f1fe1fac65399406bfe000bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd5c567b5a6222f47ad7af9c470e806c5518d85dd37bdd614859217a0b6b7ad6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    resource "test_input.excalidraw" do
      url "https:raw.githubusercontent.comsindrelexcalidraw-converterrefsheadsmastertestdatatest_input.excalidraw"
      sha256 "46fd108ab73f6ba70610cb2a79326e453246d58399b65ffc95e0de41dd2f12e8"
    end

    resource("test_input.excalidraw").stage testpath
    system bin"excalidraw-converter", "gliffy", "-i", testpath"test_input.excalidraw", "-o",
testpath"test_output.gliffy"
    assert_path_exists testpath"test_output.gliffy"
  end
end