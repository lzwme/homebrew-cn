class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.24.0/nifi-registry-1.24.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.24.0/nifi-registry-1.24.0-bin.zip"
  sha256 "df7aae206569ae61edb12d6c8e06783d7263fc1c22c8cb6a97109f9125d5a8b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6d36500ffff8a6fac2a15eaf3c07195a4521e0fdeabf902103987b415385534"
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