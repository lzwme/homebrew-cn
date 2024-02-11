class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.2.1.tar.gz"
  sha256 "97995612ac7182f60bb0258436f7fa66f3a4e1436834ed7c70e99effed05e523"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "494ae12a329238f81dc09cb1fcd17f66b2c2f297121eb13a4315771058e2e952"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f15f544cdb4fa73945e604bf31963e55e2d43abcc0cacec7241b2e990501165"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3e3cfed7963898d2b108ba5bfcf8e7533bbe6868326132f01c25acc3618f33"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b824c4a07de6e9269eac1be124990744d81ac42f428b2b34eaf3c2951c89566"
    sha256 cellar: :any_skip_relocation, ventura:        "afb0a106f917f92ffd129d0f5243ec7f976452c020a4e181c7cbaa15bea1d6a9"
    sha256 cellar: :any_skip_relocation, monterey:       "71d0bf3fbf0af5270bd78eaf22949ddf318e9c22035313036f418c0bc2a6917e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b968d856e277f4b405857d5b2b74246c9b0f829e6d155983e013d0684851ec71"
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