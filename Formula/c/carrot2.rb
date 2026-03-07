class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://search.carrot2.org/"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.8.5",
      revision: "1d25fb74183ced9070e1d2af2e82cd8842065791"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3ebf558eca09889cb51eab971329ed53702e48822312c681813f2784c830e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0a93b28f4da7e0de0cbbbed609ee66b9c413a5e116f7e4e95e4e528812ddf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c054da7dc2bff467c6f82d3181b14eb2c5a6e55076664db3e779f1ab8ee9acd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c650b18f7294a033dd0da63691d2484df8d568e88cc3fb1d597871adbfbec7cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "040336ac829a9b85f5740271dbd51a758d94463c90065f1b9fc8085445c33249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2e5e829cbc7f6e77d24f2a4716f7543aafc373671e1dc0affe4c1cac5a0d08"
  end

  depends_on "gradle" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  on_linux do
    on_arm do
      depends_on "python-setuptools" => :build
    end
  end

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/wrapper/gradle-wrapper.properties", "gradle-9.3.1", "gradle-#{Formula["gradle"].version}"

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
      JAVA_CMD:    "exec '#{Formula["openjdk"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  service do
    run opt_bin/"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    spawn bin/"carrot2", "--port", port.to_s
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end