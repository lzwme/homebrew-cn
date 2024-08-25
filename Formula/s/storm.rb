class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.3/apache-storm-2.6.3.tar.gz"
  sha256 "79e6ffade8cfa1185bd00836e3f300cff88d830eb070ea2ec217442d1143d316"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0af6f7edc25f92c2aaae19a011f58d988a348732d15a7e4655a1006728f444d2"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang, libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end