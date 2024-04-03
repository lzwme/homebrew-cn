class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https:www.elastic.coproductslogstash"
  url "https:github.comelasticlogstasharchiverefstagsv8.13.1.tar.gz"
  sha256 "5c3f8e70463baabd87ae4ae32e31b924d3be65ea6452058a97e29b4ddbfed9f1"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comelasticlogstash.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70ab6e5b6b6012353a0dafcbf9c39fb692ae0723b79a9447a961b87c8c457ee4"
    sha256 cellar: :any,                 arm64_ventura:  "1235b3a303c56a5a41cd7a1b6ef071dac5236c42784142981ae877cef73f7e1e"
    sha256 cellar: :any,                 arm64_monterey: "0a98fd3be69b1c9f69b78d390865d1ce84da818092961e5f3966ee8802abe402"
    sha256 cellar: :any,                 sonoma:         "0e84feb91765135c5d54d81c327efac69c2ac1d0476cb5e909376fb4376b74f8"
    sha256 cellar: :any,                 ventura:        "2cd15ae58b3bec19db45ad920d9819b79ec31625a72354708bf646a78d5dfcb1"
    sha256 cellar: :any,                 monterey:       "be63657f6e564dcb4ad1a507aaf5ce870028cbbda485e04e885473c0f2a658e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918dbb2411204d4ff9addeb56b2e3ece62a9cc96b0e6323473bb2e5697b8d160"
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
    (libexec"config").rmtree

    bin.install libexec"binlogstash", libexec"binlogstash-plugin"
    bin.env_script_all_files libexec"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("17")}}"

    # remove non-native architecture pre-built libraries
    paths = [
      libexec"vendorjrubylibrubystdliblibfixposixbinary",
    ]
    paths.each do |path|
      path.each_child { |dir| dir.rmtree unless dir.to_s.include? Hardware::CPU.arch.to_s }
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
    (testpath"configlogstash.yml").write <<~EOS
      path.queue: #{testpath}queue
    EOS
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