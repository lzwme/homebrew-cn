class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://dlcdn.apache.org/storm/apache-storm-2.6.4/apache-storm-2.6.4.tar.gz"
  sha256 "ed1367cea880d093c3722c6f90a8dcdf89aaa59efeed38b607c9d8d405d43e5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce0e2d92dacba7041e54790d524b9f9953716371a536a2261b4999f876b49b09"
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