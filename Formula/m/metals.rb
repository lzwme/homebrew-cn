class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.3.4.tar.gz"
  sha256 "ee27359b9c27ed391fd22525b88e040f9542ed92a0f5c3f04690a5e999adb393"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84b57b78ef814ff0e942726599b71346b812df7b75811a542bcf6488f0fb6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5b785703707f62dff07f9e83e3f35613566433fa64fa57f5fa236297800724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38a63fb14ca6d378d7bd10b4a09b1e3eadcb31f34af9160b68ffb0829381cf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "300dca73862fa3d42e85c9d750a04be9c7b6a74d2fecc40233c6b10f7e63f0cf"
    sha256 cellar: :any_skip_relocation, ventura:        "7726e3f84abfeb7f9cba736a7ab0e0496098a45c17e880f8e2ec797760bf2772"
    sha256 cellar: :any_skip_relocation, monterey:       "ea6e1faf5ffb18dba85ae7405aedec46fe150780761fd0a40e92025c48a702b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11689545b41667d44baf57e373b7d5d1877527344a3bafd9595e83758e4fd1ed"
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