class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.0/apache-storm-2.6.0.tar.gz"
  sha256 "358e182d5e5c711865d2fdd5d91f71184399b40064ecd0e7d4a7741047002c95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "886797baa14e2c36198e927105de0aafe8398e515ef2bb071b516df9f155a4dd"
  end

  depends_on "openjdk"
  depends_on "python@3.12"

  conflicts_with "stormssh", because: "both install 'storm' binary"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang, libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end