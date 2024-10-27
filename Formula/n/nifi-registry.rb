class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.28.0/nifi-registry-1.28.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.28.0/nifi-registry-1.28.0-bin.zip"
  sha256 "6422273f1a19f15a1e8a3c4ec33f0384c8456acb5ae2726465eb37cca90e5b5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b82edf4439edff14c22465efdba07c159b5e3db0ab55499cf4ab757b9c1317ee"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end