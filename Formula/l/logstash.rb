class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://ghproxy.com/https://github.com/elastic/logstash/archive/refs/tags/v8.11.0.tar.gz"
  sha256 "38bcc62a5665ea6b8cac6e21245f8072358814b46c244c456e0c704e51645e81"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "58acb1926ffd50c777a9fa6fa676867e621b71153e8b815591bba200a3e5ea66"
    sha256 cellar: :any,                 arm64_ventura:  "20b5f8fc54f1ae56ed8dea2dd11e877ddabd7efd33e008b37b902f82b3f346ca"
    sha256 cellar: :any,                 arm64_monterey: "8ab98a3441dc4bf5e6ebfae249503101808876765297da25522919c3ece224aa"
    sha256 cellar: :any,                 sonoma:         "82f6607d5b41a6b24d013876f4898bf0aa6f1164a96927ea713de4e1cd77a06e"
    sha256 cellar: :any,                 ventura:        "b39a028dd49580905371a82812eb9b0c0d4f013e7287d174ef03c42ad48a9bd4"
    sha256 cellar: :any,                 monterey:       "c8eaf6bc3a7e55b5313de99b93796704461b6e3a0056da9fca64086d1ac4e97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f06119af76db38deb0534b335c9279f7171631093f09aefb549f4e154bdcf8f"
  end

  depends_on "openjdk@17"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"
    ENV["OSS"] = "true"

    # Build the package from source
    system "rake", "artifact:no_bundle_jdk_tar"
    # Extract the package to the current directory
    mkdir "tar"
    system "tar", "--strip-components=1", "-xf", Dir["build/logstash-*.tar.gz"].first, "-C", "tar"
    cd "tar"

    inreplace "bin/logstash",
              %r{^\. "\$\(cd `dirname \$\{SOURCEPATH\}`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash-plugin",
              %r{^\. "\$\(cd `dirname \$0`/\.\.; pwd\)/bin/logstash\.lib\.sh"},
              ". #{libexec}/bin/logstash.lib.sh"
    inreplace "bin/logstash.lib.sh",
              /^LOGSTASH_HOME=.*$/,
              "LOGSTASH_HOME=#{libexec}"

    # Delete Windows and other Arch/OS files
    paths_to_keep = OS.linux? ? "#{Hardware::CPU.arch}-#{OS.kernel_name}" : OS.kernel_name
    rm Dir["bin/*.bat"]
    Dir["vendor/jruby/tmp/lib/jni/*"].each do |path|
      rm_r path unless path.include? paths_to_keep
    end

    libexec.install Dir["*"]

    # Move config files into etc
    (etc/"logstash").install Dir[libexec/"config/*"]
    (libexec/"config").rmtree

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("17")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary",
      libexec/"vendor/bundle/jruby/3.1.0/gems/ffi-binary-libfixposix-0.5.1.1-java/lib/libfixposix/binary",
    ]
    paths.each do |path|
      path.each_child { |dir| dir.rmtree unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
    rm_r libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary/arm64-darwin" if OS.mac? && Hardware::CPU.arm?
  end

  def post_install
    ln_s etc/"logstash", libexec/"config"
  end

  def caveats
    <<~EOS
      Configuration files are located in #{etc}/logstash/
    EOS
  end

  service do
    run opt_bin/"logstash"
    keep_alive false
    working_dir var
    log_path var/"log/logstash.log"
    error_log_path var/"log/logstash.log"
  end

  test do
    # workaround https://github.com/elastic/logstash/issues/6378
    (testpath/"config").mkpath
    ["jvm.options", "log4j2.properties", "startup.options"].each do |f|
      cp prefix/"libexec/config/#{f}", testpath/"config"
    end
    (testpath/"config/logstash.yml").write <<~EOS
      path.queue: #{testpath}/queue
    EOS
    (testpath/"data").mkpath
    (testpath/"logs").mkpath
    (testpath/"queue").mkpath

    data = "--path.data=#{testpath}/data"
    logs = "--path.logs=#{testpath}/logs"
    settings = "--path.settings=#{testpath}/config"

    output = pipe_output("#{bin}/logstash -e '' #{data} #{logs} #{settings} --log.level=fatal", "hello world\n")
    assert_match "hello world", output
  end
end