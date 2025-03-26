class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https:www.elastic.coproductslogstash"
  url "https:github.comelasticlogstasharchiverefstagsv8.17.4.tar.gz"
  sha256 "63f12d33057c28ae69dbcf930c57f34a6d3187c3fd091d37da68683df4c7f18b"
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comelasticlogstash.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "996e9be3f3bca3a7fdc5fd445edd2ce00a7c1c7bb6161fdce139726e500d6a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "866eb43de67e5b11ae6e5513c7a29b8928d17965edffad36b435041520e3a6f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b3eb714847e97c5e2f9b2e2da888f159899ad0f4bdef22a616037de063c4b0d"
    sha256 cellar: :any,                 sonoma:        "91c725a4c0332bddf8fd1baf8a07bce8906cd05e09b6929c87f8e85cb34477b9"
    sha256 cellar: :any,                 ventura:       "2f78f5017de83e7568a660e6b9b7cdc28124c3e3dcdd24d4f01ddcad5b10335f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b5da7297aac978dee0944ba7079ceda7a268044fbc6a763bbb54fb85897498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d27c6f535052f92575953902e1ce2b61b903ed794bf0ac88332bdd7b4bc4f5d"
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
    bin.env_script_all_files libexec"bin", LS_JAVA_HOME: "${LS_JAVA_HOME:-#{Language::Java.java_home("21")}}"

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