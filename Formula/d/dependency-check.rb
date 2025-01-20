class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https:owasp.orgwww-project-dependency-check"
  url "https:github.comjeremylongDependencyCheckreleasesdownloadv12.0.1dependency-check-12.0.1-release.zip"
  sha256 "f7783e31efc9649e810b0e885cb85f3bc2f8919097af95c4c7fd16c0827cba7e"
  license "Apache-2.0"
  head "https:github.comjeremylongDependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a327dcd1b7993f32a8b11be195fecbb5d7640128623e84a9e63a2d0c6b8f6e4"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin*.bat"])

    chmod 0755, "bindependency-check.sh"
    libexec.install Dir["*"]

    (bin"dependency-check").write_env_script libexec"bindependency-check.sh",
      JAVA_HOME: Formula["openjdk"].opt_prefix

    (var"dependencycheck").mkpath
    libexec.install_symlink var"dependencycheck" => "data"

    (etc"dependencycheck").mkpath
    jar = "dependency-check-core-#{version}.jar"
    corejar = libexec"lib#{jar}"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", libexec"etc"
    (etc"dependencycheck").install_symlink libexec"etcdependencycheck.properties"
  end

  test do
    # wait a random amount of time as multiple tests are being on different OS
    # the sleep 1 seconds to 30 seconds assists with the NVD Rate Limiting issues
    sleep(rand(1..30))
    output = shell_output("#{bin}dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
      analyzer.dependencymerging.enabled=false
      analyzer.dependencybundling.enabled=false
    EOS
    system bin"dependency-check", "-P", "temp-props.properties", "-f", "XML",
              "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath,
              "--nvdDatafeed", "https:jeremylong.github.ioDependencyCheckhb_nvd",
              "--disableKnownExploited"
    assert_predicate testpath"dependency-check-report.xml", :exist?
  end
end