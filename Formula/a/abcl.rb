class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.9.2/abcl-src-1.9.2.tar.gz"
  sha256 "4e2f4b8f85e2d95d95e5bdbcd9fa17ad6131a17e2fcf12bc19ffb97b48bc1d38"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url :homepage
    regex(/href=.*?abcl-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cde97a77b73cdec4bb00bbec261b1486d8f742e50e166edd4b64a65b5c725dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c365f98413ab1f6e6e88a59dfd662e975855b8583e04b4945e1c0900eb2f85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820338d8d274276e466d84616bfb820f181b30dee53860f38bd3b737c542e301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0e7ee7fc02acb7e4e81debdaefece5fa62eb5129eca94247b4f53628766c104"
    sha256 cellar: :any_skip_relocation, sonoma:         "87fc8d8c17166264571f39ab53428c48246cef454f31a2a631ac50a68606e82e"
    sha256 cellar: :any_skip_relocation, ventura:        "682505e8bf32bcd1c89bab05bee6563ef541cdcee8cb563ad0b9a37e3777aa39"
    sha256 cellar: :any_skip_relocation, monterey:       "923b22698e40554a1920f55c4657153a236e3a3dad6a48266f84ec740dbba6ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a077488cce7889466e0cd135e9c83d5d6c1425d7b3f794d9ed863ed6c70056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461c7a8fe2a872e92ff82e19767b6b80cb69cb6985676ef751dc169fc05737ab"
  end

  depends_on "ant"
  depends_on "openjdk"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "ant", "abcl.properties.autoconfigure.openjdk.8"
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write_env_script "rlwrap",
                                  "java -cp #{libexec}/abcl.jar:\"$CLASSPATH\" org.armedbear.lisp.Main",
                                  Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match(/"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip)
  end
end