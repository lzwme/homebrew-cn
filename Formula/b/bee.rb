class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://ghfast.top/https://github.com/bluesoft/bee/releases/download/1.111/bee-1.111.zip"
  sha256 "01500355cbbd465157a357a7b1a8902edeeb9ae72fe8fda9090bf76e0ab470f9"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a28352a11accc1cc5951a9e1b94ac6d0060c444ce2fc0e1468b3f537dd416e8"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    (bin/"bee").write_env_script libexec/"bin/bee", Language::Java.java_home_env
  end

  test do
    (testpath/"bee.properties").write <<~EOS
      test-database.driver=com.mysql.jdbc.Driver
      test-database.url=jdbc:mysql://127.0.0.1/test-database
      test-database.user=root
      test-database.password=
    EOS
    (testpath/"bee").mkpath
    system bin/"bee", "-d", testpath/"bee", "dbchange:create", "new-file"
  end
end