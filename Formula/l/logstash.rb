class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://ghfast.top/https://github.com/elastic/logstash/archive/refs/tags/v9.1.1.tar.gz"
  sha256 "2e6cdacdbc7bbe1e1266a5e3a7d0744010de1adc2403ae67f8cc2f458abf53f0"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca0c6d31f900a4c863682ac1a3f9679daec4434174e2362c462c52d61199a6cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6c47123ddd3e6379b703db5856c3c7fba928f861945e229ebcaaea932a0424e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71039db054d49c057fdc9d18bbf676da2d63553810d80b3c137ed0d2ecc2b713"
    sha256 cellar: :any,                 sonoma:        "1f1c5658a59a3afeea0260436ef1249e286dcb685fc0b4c72831f3291290dbe8"
    sha256 cellar: :any,                 ventura:       "5659881e6b523f5c57b1932c344d7e9245a5043bad9b9cef6868019d997f4574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7485442fe75a96249db121034739820acb9d4ac4e155a51c807f1e5a236777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4b9cbf19af9c357134fca93b08e8f7c7281c5ecdf4d6ba75ba21811706a720"
  end

  depends_on "openjdk@21"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_r("x-pack")
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
    rm_r(libexec/"config")

    bin.install libexec/"bin/logstash", libexec/"bin/logstash-plugin"
    bin.env_script_all_files libexec/"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("21")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary",
    ]
    paths.each do |path|
      path.each_child { |dir| rm_r(dir) unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
    rm_r libexec/"vendor/jruby/lib/ruby/stdlib/libfixposix/binary/arm64-darwin" if OS.mac? && Hardware::CPU.arm?
  end

  def post_install
    ln_s etc/"logstash", libexec/"config" unless (libexec/"config").exist?
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
    (testpath/"config/logstash.yml").write <<~YAML
      path.queue: #{testpath}/queue
    YAML
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