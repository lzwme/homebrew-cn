class Rhino < Formula
  desc "JavaScript engine"
  homepage "https://mozilla.github.io/rhino/"
  url "https://repo.maven.apache.org/maven2/org/mozilla/rhino-all/1.8.1/rhino-all-1.8.1.jar"
  sha256 "8bb0b8b4f6a86a584d04d704c7109bf9bc2817be85679a15259d1ea51b1f6cd7"
  license "MPL-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mozilla/rhino/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1c1ffde73208a8a6b79c50442926e42dd8cb676a1b8ae49b504febf74e1176f"
  end

  depends_on "openjdk@21"

  conflicts_with "nut", because: "both install `rhino` binaries"

  def install
    libexec.install "rhino-all-#{version}.jar" => "rhino.jar"
    bin.write_jar_script libexec/"rhino.jar", "rhino", java_version: "21"
  end

  test do
    assert_equal "42", shell_output("#{bin}/rhino -e \"print(6*7)\"").chomp
  end
end