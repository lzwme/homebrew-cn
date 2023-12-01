class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.24.0/nifi-1.24.0-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.24.0/nifi-1.24.0-bin.zip"
  sha256 "bd449674fdef7fd651e0d020b7f97761f4999a99b4e6c7d413d3e2e5e580f0d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "184c4b5fed7e000c683646919e1b8068c76aa3bc3cfada138fcad82b548ef173"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end