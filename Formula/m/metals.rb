class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.4.1.tar.gz"
  sha256 "6c2e091409af7ed2e987378a60ffdb9f8f9f268febb1f3b33f44e78b94e9d4a4"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb9ee98b90b979934d17115c66088419bb66373a07671fd18fae13859c3987d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af896d9a12e2b4390f8d6d166a716599702e72e5e18621a87eb0dcbce666b93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "398ead473c97bb508414562fa792a2a2a76385ee0e0dd13d422eb3f9df87b72d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5a9057912f4c123fc90ea35f91eac2e6fdcb1f95a544b6b72e105811423b56"
    sha256 cellar: :any_skip_relocation, ventura:       "78ebca3e6015135cd39ae6385faa353bccd4d4457a9f17ba8d4d81329bc9d78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bfd680deacc1f184e375e6c05efd313274220e7e544cdf4bff1cbb60be5b438"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", version ~=.+?,m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = ^.+?Attributed\((.+?\.jar)\).*$
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metalsdependencyClasspath' 2>devnull")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec"lib").install jar
    end

    (libexec"lib").install buildpath.glob("metalstargetscala-*metals_*-#{version}.jar")
    (libexec"lib").install buildpath.glob("mtagstargetscala-*mtags_*-#{version}.jar")
    (libexec"lib").install buildpath.glob("mtags-sharedtargetscala-*mtags-shared_*-#{version}.jar")
    (libexec"lib").install "mtags-interfacestargetmtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec"lib"}*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOMEbin:$PATH"
    (bin"metals").write_env_script "java", args.join(" "), env
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
    Open3.popen3(bin"metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end