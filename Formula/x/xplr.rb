class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https:github.comsayanarijitxplr"
  url "https:github.comsayanarijitxplrarchiverefstagsv0.21.5.tar.gz"
  sha256 "c6e2b800888363c6d6101eafe585723a5bf9cc304cedff77a302c0e2a6d0a151"
  license "MIT"
  head "https:github.comsayanarijitxplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d983a8db6be6c12d07ffe368eec9a31d6f748507a0034f63d8f7b8794f484ccb"
    sha256 cellar: :any,                 arm64_ventura:  "dc5daebb3294ccb64053293da12d7262699934812f1dae43cd9e8b6ea2a84ab1"
    sha256 cellar: :any,                 arm64_monterey: "d1dd3855ff3099c7c5b41ed93b68c5f9271f9475e6eed4f26d872b1d2111199a"
    sha256 cellar: :any,                 sonoma:         "a089019f3c3d65e8ac9dfae5e1da9e8642f405a80309c10d42e63a238deb75d4"
    sha256 cellar: :any,                 ventura:        "d9c4b7786b218413fac34063c1031cc87b2384ea460cca7b70bc06c2854cba14"
    sha256 cellar: :any,                 monterey:       "0b6f202f477034c9ce36221f22e8423c57232f32773449e268a683c317739b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec4a296ef77d536a944c9e591507ec46952ce2ea14c130fe57162c1f92c6de4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  # Avoid vendoring `luajit`.
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    input, = Open3.popen2 "SHELL=binsh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert check_binary_linkage(bin"xplr",
                                Formula["luajit"].opt_libshared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end

__END__
diff --git aCargo.toml bCargo.toml
index 48bd3e1..69cdd17 100644
--- aCargo.toml
+++ bCargo.toml
@@ -73,7 +73,7 @@ features = ['serde']
 
 [dependencies.mlua]
 version = "0.9.2"
-features = ['luajit', 'vendored', 'serialize', 'send']
+features = ['luajit', 'serialize', 'send']
 
 [dependencies.tui-input]
 version = "0.8.0"