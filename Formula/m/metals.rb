class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.4.0.tar.gz"
  sha256 "0eb6abaa1ebcb8875fa25572dfca164ed9b8fbbb2ce2f6fb4019225f107f049d"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98a9ab26bfb783c6789afed041ac6ca9f20a6383a0b46a729214a0db5fbd7521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386704b2abed4d2c33a7331828302073103f722cd4a55a076ac78858d304c85a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf605e6647a99386db932778a3440ee650547dfe6c261091dba807e01ff57d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "24908b4a15a4fa2e655da8248300365c2913ad989c8fadc1b31e61d1c54fb353"
    sha256 cellar: :any_skip_relocation, ventura:       "563190e160e4df63e45d3530a413e080d6f76e6e321d6e06581ce40de255c616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7449efc9d2ef613d1f14e7b974468a11427638515732fb4a8517dcda8ea934"
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