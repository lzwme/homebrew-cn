class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https:gluon-lang.org"
  # TODO: Remove deprecation if new release is available that fixes build
  url "https:github.comgluon-langgluonarchiverefstagsv0.18.2.tar.gz"
  sha256 "b5f82fecdf56b8b25ed516a023d31bcaf576b2bb3b2aee3e53d6f50ea8f281a3"
  license "MIT"
  head "https:github.comgluon-langgluon.git", branch: "master"

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4f5001264f56d18739d145b9e9423a5e3bfd2e31cbed0649f082516e4f5687d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4393342b66ede5869953b964c303cba89caace2051937c99c114d9c21d980ead"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aefe7045d9ef7fa7830a90e2e794c0f68926bae742f402764d442cd360ddaae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "27627946ae35b4b9e35631903c1cbcb9bcd857375f2d035e3dfa400ab9f77ee9"
    sha256 cellar: :any_skip_relocation, ventura:        "03b4837e4adabb86f4e12acf9310b7888560c97608473b27c230fcd57f1ed88f"
    sha256 cellar: :any_skip_relocation, monterey:       "64fb0c4cda091c3e4ef737ba21f06c9e43bcac513af09f6057b077f11c86e793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba2ee59f07103937ec724410329016ff048f6da389b45b78fca28a63f11c18d1"
  end

  # Unable to builds functional binaries since Rust 1.81.0.
  # Issue ref: https:github.comgluon-langgluonissues967
  deprecate! date: "2024-11-07", because: :does_not_build

  depends_on "rust" => :build

  def install
    cd "repl" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}gluon test.glu")
  end
end