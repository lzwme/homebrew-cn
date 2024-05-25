class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https:search.carrot2.org"
  url "https:github.comcarrot2carrot2.git",
      tag:      "release4.6.0",
      revision: "a29bd71366f2ac3c135ee1a9cb9da3748954e088"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "316e0b843788f87a4fc950905d572f191dec3a22c6be0f50e794b7d3998b5b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f767a93a5fc89cc44e5c212ed3e7a25bef7dca2a029ffcc5ce167fa935c8754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a294204538f9fc2282d585501a42e2445b701374f4b6211c9a13fa641e7e07ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "735a5f21733a85c406478d037bb04e0aaf0850eacb4acf10a32cfb11ae9d8229"
    sha256 cellar: :any_skip_relocation, ventura:        "4eb89597731157708f85ee4667a4465623c433848d1c5d1f0f86ec887e0fec9e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac3622ebbbd5de4f0a250679e01cbcbbda9bebae8c4beee4756d7b485f9904d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c26f5920ee5eb1571ecf1f34850bc07c6da816afb2a55734c660cb78709e470"
  end

  depends_on "gradle" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradlevalidationcheck-environment.gradle",
      expectedGradleVersion = '[^']+',
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    # Use yarn and node from Homebrew
    inreplace "gradlenodeyarn-projects.gradle", "download = true", "download = false"
    inreplace "versions.toml" do |s|
      s.gsub! "node = \"18.18.2\"", "node = \"#{Formula["node"].version}\""
      s.gsub! "yarn = \"1.22.19\"", "yarn = \"#{Formula["yarn"].version}\""
    end

    system "gradle", "assemble", "--no-daemon"

    cd "distributionbuilddist" do
      inreplace "dcsconfloggingappender-file.xml", "${dcs:home}logs", var"logcarrot2"
      libexec.install Dir["*"]
    end

    (bin"carrot2").write_env_script "#{libexec}dcsdcs",
      JAVA_CMD:    "exec '#{Formula["openjdk"].opt_bin}java'",
      SCRIPT_HOME: libexec"dcs"
  end

  service do
    run opt_bin"carrot2"
    working_dir opt_libexec
  end

  test do
    port = free_port
    fork { exec bin"carrot2", "--port", port.to_s }
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}servicelist")
  end
end