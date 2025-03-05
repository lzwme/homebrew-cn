class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https:www.elastic.coproductslogstash"
  url "https:github.comelasticlogstasharchiverefstagsv8.17.3.tar.gz"
  sha256 "bff528c9ad73294393e875c94e3014d104879a1b19153570e182f8e556c4cb93"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comelasticlogstash.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea864fb804819bdfbb0b87ad67d8fd1272373e6efc6c3f8dd493ab518885858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f99c1ea576143026991cca725c2ec24cf6732b9fc69ff8efa77d67d4d2f3f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72081ca85e9a97e3bf6ca69b2824eae2498f64b3ea55b3000ff41e1fb389906a"
    sha256 cellar: :any,                 sonoma:        "6b1c41559bc8c8217fa5fb87648062b37e0da9e19fbe7c0803ba5f597192b4dc"
    sha256 cellar: :any,                 ventura:       "6d84b198011fbef1331bcb1921ebbc39284d8580a1b97c2d97d19bf2b96c3dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1062bf4edc476a537dc665eb04426f17b8076d94a2370eb398df7b9ba8608dd"
  end

  depends_on "openjdk@17"

  uses_from_macos "ruby" => :build

  def install
    # remove non open source files
    rm_r("x-pack")
    ENV["OSS"] = "true"

    # Build the package from source
    system "rake", "artifact:no_bundle_jdk_tar"
    # Extract the package to the current directory
    mkdir "tar"
    system "tar", "--strip-components=1", "-xf", Dir["buildlogstash-*.tar.gz"].first, "-C", "tar"
    cd "tar"

    inreplace "binlogstash",
              %r{^\. "\$\(cd `dirname \$\{SOURCEPATH\}`\.\.; pwd\)binlogstash\.lib\.sh"},
              ". #{libexec}binlogstash.lib.sh"
    inreplace "binlogstash-plugin",
              %r{^\. "\$\(cd `dirname \$0`\.\.; pwd\)binlogstash\.lib\.sh"},
              ". #{libexec}binlogstash.lib.sh"
    inreplace "binlogstash.lib.sh",
              ^LOGSTASH_HOME=.*$,
              "LOGSTASH_HOME=#{libexec}"

    # Delete Windows and other ArchOS files
    paths_to_keep = OS.linux? ? "#{Hardware::CPU.arch}-#{OS.kernel_name}" : OS.kernel_name
    rm Dir["bin*.bat"]
    Dir["vendorjrubytmplibjni*"].each do |path|
      rm_r path unless path.include? paths_to_keep
    end

    libexec.install Dir["*"]

    # Move config files into etc
    (etc"logstash").install Dir[libexec"config*"]
    rm_r(libexec"config")

    bin.install libexec"binlogstash", libexec"binlogstash-plugin"
    bin.env_script_all_files libexec"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("17")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec"vendorjrubylibrubystdliblibfixposixbinary",
    ]
    paths.each do |path|
      path.each_child { |dir| rm_r(dir) unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
    rm_r libexec"vendorjrubylibrubystdliblibfixposixbinaryarm64-darwin" if OS.mac? && Hardware::CPU.arm?
  end

  def post_install
    ln_s etc"logstash", libexec"config" unless (libexec"config").exist?
  end

  def caveats
    <<~EOS
      Configuration files are located in #{etc}logstash
    EOS
  end

  service do
    run opt_bin"logstash"
    keep_alive false
    working_dir var
    log_path var"loglogstash.log"
    error_log_path var"loglogstash.log"
  end

  test do
    # workaround https:github.comelasticlogstashissues6378
    (testpath"config").mkpath
    ["jvm.options", "log4j2.properties", "startup.options"].each do |f|
      cp prefix"libexecconfig#{f}", testpath"config"
    end
    (testpath"configlogstash.yml").write <<~YAML
      path.queue: #{testpath}queue
    YAML
    (testpath"data").mkpath
    (testpath"logs").mkpath
    (testpath"queue").mkpath

    data = "--path.data=#{testpath}data"
    logs = "--path.logs=#{testpath}logs"
    settings = "--path.settings=#{testpath}config"

    output = pipe_output("#{bin}logstash -e '' #{data} #{logs} #{settings} --log.level=fatal", "hello world\n")
    assert_match "hello world", output
  end
end