class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://ghproxy.com/https://github.com/elastic/logstash/archive/refs/tags/v8.11.2.tar.gz"
  sha256 "e87d09249720b2e2a2f451ae8d51ec8896212e70db99681e975529f2ca17ac92"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d9661a307c30601e347b81c64d1903448f27aebaac751694444f513119da64b"
    sha256 cellar: :any,                 arm64_ventura:  "bd931b3edfb35309f65515b95dc5790e3c3dc9c805cb838c27ca588739ee03a5"
    sha256 cellar: :any,                 arm64_monterey: "afc2a303a8ce1888009d5c845cde556dd8583a650e50108a3d5b1eb18b516c73"
    sha256 cellar: :any,                 sonoma:         "72312a65163213db55f9bda2a37c085349259679338842b8693e2f4d62b85166"
    sha256 cellar: :any,                 ventura:        "934257718d55881d7934812cf9959e504c4edd2a7a4e8e56f2c63a787a2f6790"
    sha256 cellar: :any,                 monterey:       "baa8d7a092dccbce8cfb1cce687be5a347f903814ff4e2d0f2791e9341e4b93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21d8b97eee3546ee7f01e6c702835e3800d7c5675824076fae14c79acfe220f"
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