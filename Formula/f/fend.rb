class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https:printfn.github.iofend"
  url "https:github.comprintfnfendarchiverefstagsv1.5.2.tar.gz"
  sha256 "cc8ce470b8a08ec5c5973d5251987f12bbc3baa7137295c42e7d782b7b297786"
  license "MIT"
  head "https:github.comprintfnfend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d082d1eb3a649fab318b62292850a140c6f9509a43c585aeabb1464ad2b1604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70efb2ed0f28b67eca5d11db4554757ba3d20b6a6bb3c7fcb1d71c21339a12c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c7f92df9f164b30559cdc214d6e1e54d0d037a81d1cade6a8b8e4897553804e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc0440a34763f1916f0c7fccf4d6bbc6ce4e05aa35aca0b320b4d1a1462d80a6"
    sha256 cellar: :any_skip_relocation, ventura:       "2d02fa9539e1c05d36a00ef3d13ccae2c6cb916b9f5448104544a5106a2e3211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e70f73f8834dba629f3906aa77597e82233f986ce6f4f4f3ea07c03817d05d2"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")
    system ".documentationbuild.sh"
    man1.install "documentationfend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}fend 1 km to m").strip
  end
end