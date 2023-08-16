class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.0/nifi-registry-1.23.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.23.0/nifi-registry-1.23.0-bin.zip"
  sha256 "978b7fe75c6207a8272b1d43b6ce1b44091158bc5169bf64d864df2d94db120b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc6525cc747591b5a1697d54c482da7e976e52f1ba99c26378736d2f59fa03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa18ef6c549b360118684ddf45b29cc3b3d3bbbc48d4c1ad45b037d67af0104d"
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