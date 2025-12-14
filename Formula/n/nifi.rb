class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.1/nifi-2.7.1-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.1/nifi-2.7.1-bin.zip"
  sha256 "90be8829870daea0eb405ee8eada0bb20dff7a81c8dadf7535da4326dc3d3a95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b773db64539f4126ec1178a6704882972ba581a543f372153393fdd2e0e3b77e"
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