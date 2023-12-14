class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://ghproxy.com/https://github.com/scalameta/metals/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "96fde076ec2441fb98346819b32ef6ef06e7603d4c28ac2479838aa8a636fc1d"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7df948adde53ff0f74ae1b9b65de11546dc77da5b85d9f956c5d2b1405fb31b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c00d4067ddddf2bc55b0f4180704b5cec5bbbf0ea466b2145f892571605b059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3453571db86d0a0809f15d34c7bca272d7b08bbcbef7a314378f4687f440d3a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "28994821ce78c8b28873802551e623657420a71bfe048fc1b9c8d1f9f7cf6b6f"
    sha256 cellar: :any_skip_relocation, ventura:        "c2d6bf537ffd219e570efad8892484f894679eb103cced63884bed2c9afccb6f"
    sha256 cellar: :any_skip_relocation, monterey:       "c9789afbb4441d3aa265f5804b7255c57ad2c670cd56c3532ff8a290d87ebf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03781819221fe3dc6f715399c9df84536540ae0acf16d9e581b72664525793ec"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@17"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metals/dependencyClasspath' 2>/dev/null")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    (libexec/"lib").install buildpath.glob("metals/target/scala-*/metals_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env("17")
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"metals").write_env_script "java", args.join(" "), env
  end

  test do
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3("#{bin}/metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end