class Bee < Formula
  desc "Tool for managing database changes"
  homepage "https://github.com/bluesoft/bee"
  url "https://ghfast.top/https://github.com/bluesoft/bee/releases/download/1.109/bee-1.109.zip"
  sha256 "2e0f932163589fe7fb3539901770370cebf4058c060b79e0db88f08ac250a183"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "939f65b1bcde518e687adb290c7b230f1e48367deeaae24a8c664b5c5f49d802"
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