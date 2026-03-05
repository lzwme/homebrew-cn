class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://ghfast.top/https://github.com/scalameta/metals/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "ea1a52ab1cc808b116623d4e338427143314bf4e8d1eb7f6b17c02fe41f6fd97"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3077892d3aab01b0ee1eee3f670cb276e1151a3cf7c8b96915406ba0895110bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae084729f5ece70e9f2acd2af96b00ca7103c059d0b4acc7c4f578d56dea0df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "578bee2a9153a6b489dae7dd04e8dcc7c13791acfbcbe6bb290f5a188b721582"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded941071d36c0f536dcb361f51c6c4172fd5d24b0e37960ec74b352f76ef8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb1956a6f0e225f1ae206fa5d7733ecc64bdb5a8276fb55030d3d863250ed5aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7147f22d4bbed6efd9cd7100760e49316a750167bfcba58e883dad71642a164"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metals/dependencyClasspath' 2>/dev/null")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |line| line.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    (libexec/"lib").install buildpath.glob("metals/target/scala-*/metals_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env
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
    Open3.popen3(bin/"metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end