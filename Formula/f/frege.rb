class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://ghproxy.com/https://github.com/Frege/frege/releases/download/3.24public/frege3.24.405.jar"
  sha256 "f5a6e40d1438a676de85620e3304ada4760878879e02dbb7c723164bd6087fc4"
  license "BSD-3-Clause"
  revision 3

  # The jar file versions in the GitHub release assets are often different
  # than the tag version, so we can't identify the latest version from the tag
  # alone.
  livecheck do
    url :stable
    regex(/^frege[._-]?v?(\d+(?:\.\d+)+)\.jar$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "28f3c0d702b145adb8d615507d492ce37bf7309fde2dcda48b47397c2a387ffa"
  end

  depends_on "openjdk"

  def install
    libexec.install "frege#{version}.jar"
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec"
  end

  test do
    (testpath/"test.fr").write <<~EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    output = shell_output "#{Formula["openjdk"].bin}/java -Xss1m -cp #{testpath}:#{libexec}/frege#{version}.jar Hello"
    assert_equal "Hello, World!\n", output
  end
end