class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https:mahout.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=mahout0.13.0apache-mahout-distribution-0.13.0.tar.gz"
  mirror "https:archive.apache.orgdistmahout0.13.0apache-mahout-distribution-0.13.0.tar.gz"
  sha256 "87bdc86e16b5817d6b5a810b94d7389604887f7de9c680f34faaf0cbb8dabf6f"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3b7e05dbbd5838236245dd37e3ed7a1cc10d4dd151adbc7979b345cb19daab0e"
  end

  head do
    url "https:github.comapachemahout.git", branch: "trunk"
    depends_on "maven" => :build
  end

  # see https:github.comHomebrewhomebrew-corepull158322
  # https:github.comHomebrewhomebrew-corepull138608
  deprecate! date: "2024-08-03", because: "does not build with 14.1"

  depends_on "hadoop"
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    if build.head?
      chmod 755, ".bin"
      system "mvn", "-DskipTests", "clean", "install"
    end

    libexec.install "bin"

    if build.head?
      libexec.install Dir["buildtoolstarget*.jar"]
      libexec.install Dir["coretarget*.jar"]
      libexec.install Dir["examplestarget*.jar"]
      libexec.install Dir["mathtarget*.jar"]
    else
      libexec.install Dir["*.jar"]
    end

    bin.install Dir["#{libexec}bin*"]
    bin.env_script_all_files libexec"bin", JAVA_HOME: ENV["JAVA_HOME"]
  end

  test do
    (testpath"test.csv").write <<~EOS
      "x","y"
      0.1234567,0.101201201
    EOS

    assert_match "0.101201201", pipe_output("#{bin}mahout cat #{testpath}test.csv")
  end
end