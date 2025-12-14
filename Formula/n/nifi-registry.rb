class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.1/nifi-registry-2.7.1-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.1/nifi-registry-2.7.1-bin.zip"
  sha256 "8ea6e9a67b92e0f967ec6c12057aeb422438694f9830094fa50204b2a2837451"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "32f75c1cba81f985d2440e1c311fb04843c92b3274729d4e88bd97652638e356"
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