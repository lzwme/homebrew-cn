class PipeRename < Formula
  desc "Rename your files using your favorite text editor"
  homepage "https://github.com/marcusbuffett/pipe-rename"
  url "https://ghfast.top/https://github.com/marcusbuffett/pipe-rename/archive/refs/tags/1.6.6.tar.gz"
  sha256 "bf33a2bba9b2d7ca4b13d35a0e49889ba77d8295314dd187f9709fe5ae6ac629"
  license "MIT"
  head "https://github.com/marcusbuffett/pipe-rename.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e73c28741527cb6a749b35cab379548c2a6c162b5fb7a9cbe599ae17ea85e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b8491c9fcb55b9e844f48a2ab727651080e29535e791e1bf36d21ebca6ea78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97533ce476e33905239b91dd58378b19c820a22442bf956d0e152a618b6e317c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b80571f935e8a95fece6633a80b895f0219806caf3103420198e201a16f49fd9"
    sha256 cellar: :any_skip_relocation, ventura:       "52d774b0aa7e4106dbe9aa1bf8be9093227af2b4045f22ca956359b307ca6107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5407430962eaf62383ea116964cb03f03505e1cb9d88f273cde0831c307b9b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaa61ce9d5ad341d7d8766fe8e188ca6d9adade64178e69443eefb3657ed008e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.log"
    (testpath/"rename.sh").write <<~SHELL
      #!/bin/sh
      echo "$(cat "$1").txt" > "$1"
    SHELL

    chmod "+x", testpath/"rename.sh"
    ENV["EDITOR"] = testpath/"rename.sh"
    system bin/"renamer", "-y", "test.log"
    assert_path_exists testpath/"test.log.txt"
  end
end