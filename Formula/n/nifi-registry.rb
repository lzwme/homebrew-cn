class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.0/nifi-registry-2.7.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.0/nifi-registry-2.7.0-bin.zip"
  sha256 "784cb3c6d5105deb5910ee8fc62194c574f8d5de3fcc100fd5c13782500f7c6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73d730bbd52fd7c24749b0fe5866dd59efe1cf8ed19ce36bc6ddecc955b97ce5"
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