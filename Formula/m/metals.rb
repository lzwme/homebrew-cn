class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.3.3.tar.gz"
  sha256 "197a5fbe8f34dffb0827b87be98bd06c0c092da85a15fc8d26fde747c4cd1bc8"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44258593f51a77d09d2ab72ad484d592ea1ef679ae24ba1c71b3329c9e86451d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "649ad85e252d5f6d4055f70462065450915a0623d1a7d957c67b9d55ec1b0a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ca5f77ba837bc207affa84db29d3b0193e07f682322edebfe12f045d1a701b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "55d38f8d4cce6581f078a3afc17881d29df2ad53367fca4d6b3fc8d59c19c452"
    sha256 cellar: :any_skip_relocation, ventura:        "c87ec898919ac46141e894f621d290b8ecc3c7d4632054eae8499c2c6b9aaaef"
    sha256 cellar: :any_skip_relocation, monterey:       "4c142bbd2ca4abc7185ea0e483b1f6f627064626f9de4c08bd2c7d9599e7e472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69df54af9d821b63529cf440d5fd02d482fd2d492e0a64278ae75d85e40b1d72"
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
    Open3.popen3("#{bin}metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end