class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://ghproxy.com/https://github.com/elastic/logstash/archive/v8.8.0.tar.gz"
  sha256 "63cb9fda2681bcc120d233609eead887f8bc5af2d7cc131537171d6eb8610390"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/elastic/logstash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f649463d4c9cc6d31d8bb6cd0b444ab1b711c406174ad65a55ded272e742ebf"
    sha256 cellar: :any,                 arm64_monterey: "46c0eb1f87df873a75225cb0ca4114dff04ca92d979a74f34b3bac9453a84842"
    sha256 cellar: :any,                 arm64_big_sur:  "ec8b1ea79632996aeabf18eb82e0b9843b537b060d6bce22e89338c43b9c9703"
    sha256 cellar: :any,                 ventura:        "4adb9a3e722ebc6ad2477faa588307a3ddf7a18d7b1df7288082a3f89d798eea"
    sha256 cellar: :any,                 monterey:       "30a9005e201c2cea486f7851668b2c8dab8a784511a187f2a72b668411b3acca"
    sha256 cellar: :any,                 big_sur:        "f07ec014c5cef49d2458d4fb8850e38b01e7082fd54b4b5b69ea8b6d87a89692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c66fcc3a273590bec925ba642aff5fc7ca331d12d88bf8e7923dc3bb9580378"
  end

  depends_on "openjdk@17"

  uses_from_macos "ruby" => :build

  # Ruby 3.2 compatibility.
  # https://github.com/elastic/logstash/pull/14838
  patch do
    on_linux do
      url "https://github.com/elastic/logstash/commit/95870c0f7a7c008c10e848191f85a1065e7db800.patch?full_index=1"
      sha256 "b09065efe41a0098266d1243df19c6e35f4d075db06b41309c8fa791b25453f5"
    end
  end

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