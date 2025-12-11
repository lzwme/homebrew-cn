class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.0/nifi-2.7.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.0/nifi-2.7.0-bin.zip"
  sha256 "9e63a5fb5ee2c7fdc8358d3012324c698a24a5ce7682e6035d16a6af3253860e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b986f362f0b52b100003555df5a093f3b94dc639bf8e30b6d543e92bc552d60"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end