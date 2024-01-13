class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https:www.elastic.coproductslogstash"
  url "https:github.comelasticlogstasharchiverefstagsv8.11.4.tar.gz"
  sha256 "a077dfc5d01d6faf0a94c64da2bb80bbfc7f51ba003b47cf174f2f7456694a6b"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comelasticlogstash.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20e1d4824f013090d06df7cccef55aa28e7bf1b27f6b6d0e448f3d6f6bf9aa65"
    sha256 cellar: :any,                 arm64_ventura:  "47dc5dd4d5dfe1c1ab1c2c23fe097e18b2b3ba5e4725b065616c0a88ec286642"
    sha256 cellar: :any,                 arm64_monterey: "9ba891aee9fb02b590b0308f809c2cd6cb018e2f99e4758170f499316ad52c79"
    sha256 cellar: :any,                 sonoma:         "0bdb99dc0e8636cc1a4c3e4df58fae4a45b588139ddc04fa4902663a1c566096"
    sha256 cellar: :any,                 ventura:        "0541ffa30bb71d764e4f1da23a42ca744fb89e7c02b2d4be5e3afad116c5de35"
    sha256 cellar: :any,                 monterey:       "408979d2dc908c981cdc46c75774eea64b0998902102c2ed0866ba7a5456f6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94bddaa5fb4d425a85537711513348b63430c690aca861714620944b12d35ad7"
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
    ln_s etc"logstash", libexec"config"
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