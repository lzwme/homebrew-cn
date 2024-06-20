class Metals < Formula
  desc "Scala language server"
  homepage "https:github.comscalametametals"
  url "https:github.comscalametametalsarchiverefstagsv1.3.2.tar.gz"
  sha256 "c772b612f6e5bc143ed643974d63d2a3f9bd86975cfb18a8516b0984c25e7e5f"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d74f34b1372a1742bc47c6211d2d96be2b345afdf8e592b24ca8fdd13670930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ef0ad9aed4f4aef4e873458af2687c9a78a1b0e37ee3bedf72a4584defc87c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8acf59a6402cab0033942b80d193f6bf457679df9aec509702a377d8c8062780"
    sha256 cellar: :any_skip_relocation, sonoma:         "8693b1fb2d35aa3f45efc6559efbd304a9acb9c04b495b95ce5a40c547d0d459"
    sha256 cellar: :any_skip_relocation, ventura:        "b02c9b0f9c73498e2017ef81b0fb404b9074e3bdb62c2a0158acd3c9629a71db"
    sha256 cellar: :any_skip_relocation, monterey:       "fa2d4cf9c3482a958159896edf83682c300b543fa1f5731d23a710cd15767d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e45879ad9c13de73558aeb4d0ad74fda6193d5baf8b722bea99e81363baabe5"
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