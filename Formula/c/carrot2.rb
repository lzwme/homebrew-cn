class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.0",
      revision: "d876b90b19d8ee497940a47a5b05ef2569ff57e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b969f8c79df9e7ec4790ac4bbfe044bb6b65fa4d533cd0eb8c7994a7b2a8bdb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "111f08a66b9cc5ca10c04d10a4f5bfbe36e0fe3fe090d25635789e5ab4a7d421"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a9b13f380a11ef25826c2f6a74a9cfb079da522bb2c72be2e79ce664595f497"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ad6a25a5450e99d6aaefa2b0432003218bf9bfdfe5a85449c8736c5c472499"
    sha256 cellar: :any_skip_relocation, ventura:       "336a0144f339442012e7f65ab0f2c4961a368a7474254978722776286b718a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82f6714f0c80ba3e96f410f6e3b85a28abc75b659f2dd0b2767485cfe988e217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "febc755075231260d43cb0118844ae73ee2daca4f9cc6c7527e0da3df9612e97"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@21"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-8.14", "gradle-#{Formula["gradle"].version}"

    # Use yarn and node from Homebrew
    inreplace "gradle/node/yarn-projects.gradle", "download = true", "download = false"
    inreplace "gradle/libs.versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node@22"].version}\""
      s.gsub! "yarn = \"1.22.19\"", "yarn = \"#{Formula["yarn"].version}\""
    end

    system "gradle", "assemble", "--no-daemon"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs",
      JAVA_CMD:    "exec '#{Formula["openjdk@21"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  service do
    run opt_bin/"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    fork { exec bin/"carrot2", "--port", port.to_s }
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end