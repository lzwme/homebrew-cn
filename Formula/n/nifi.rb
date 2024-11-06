class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.0.0/nifi-2.0.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip"
  sha256 "ed704507592fdce3eb1fa1326906129dc845e9fc45322b5f05c31f54dfbd01bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "127d85bff0f8dcb5fb85e645af16f36139f93d5eb0ca8abbcc05659ff98d42e3"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)

    # ensure uniform bottles
    inreplace libexec/"python/framework/py4j/java_gateway.py", "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"nifi", "status"
  end
end