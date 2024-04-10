class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.2.2.tar.gz"
  sha256 "5b9998b9d3d6e224d911f83584859f626bd74180f8bf2b0d464982a8ccf470f8"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc41df6e0b16e5b516837513b6d015f5e42b3187d9b04f2d97625bb95d74b677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0448937666126f5ad9368239be7ae792927fae4d4e87f34ac885395b032d79b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26d1fdde461b54191dc14d6fdc7053372226ec19914093085e0474e4a5e767d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bbbdbfbf18624741c24eee538df7b8d3cca502ebe2db20c53cfb2df9b132e07"
    sha256 cellar: :any_skip_relocation, ventura:        "b5b5e6e355bbe82009ac43b38b03afe00a277a8ec0c8e9828582b35d4ae34073"
    sha256 cellar: :any_skip_relocation, monterey:       "ec66c45767587c0ae7f0b8c2faec6ba38319a6e9b92dcf2062cd29f3d105ea6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d0c06ef11ba787c204ec78283ee1d770593eb2a65d7e2459464b53c1b2a1de"
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