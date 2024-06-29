class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.58_20240625/wrapper_3.5.58_src.tar.gz"
  sha256 "9b07cb0997e302d28d7e9f4273c8642c038aa3a55f283de5f880e25c33f62d5f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2db02cdb12f048ac5582fac8439d58ddfbd932e2bdf9d767d4a2da0b5cadeb5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbf39ed83716a29cb1c2004e585ca0be2bfcceca3d369f7f9420cce47fcc2e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcf90e3af392d542937641e13965346aa412092cbd9c1245fd526ffb0ed87fcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b80c654b2a77251888605cf455bdea6881912f1c48b4258e588644ad01094fe"
    sha256 cellar: :any_skip_relocation, ventura:        "79f78ce0c462fa237489cea2f8dc07279ed8548c8e1b9a0ca8ed6054caef4da0"
    sha256 cellar: :any_skip_relocation, monterey:       "b1ca622f81a47cf86e66e594b3f1cbf8d61115f897f2a3772d7ad75c6272a25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceddcea959f947b37a3539215fd47c9913fbadb18c9bcb7684fd665737c66b04"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11" => :build
  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    # Default javac target version is 1.4, use 1.6 which is the minimum available on openjdk@11
    system "ant", "-Dbits=64", "-Djavac.target.version=1.6"
    libexec.install "lib", "bin", "src/bin" => "scripts"
    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_match("Test Wrapper Sample Application", output)
  end
end