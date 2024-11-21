class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https:grails.org"
  url "https:github.comgrailsgrails-corereleasesdownloadv6.2.2grails-6.2.2.zip"
  sha256 "50f81ac85a78098673a35c87848236f01c7e094abecf9137fb22a35d52d26741"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c004e5b850051a6ef9fecaef9564a40846da0fc8be387ff596eabe712aee9c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c004e5b850051a6ef9fecaef9564a40846da0fc8be387ff596eabe712aee9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c004e5b850051a6ef9fecaef9564a40846da0fc8be387ff596eabe712aee9c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d35ca3d0d15195a8e1428b73007b37a63942db05b6b73a825b8799d9f765bc59"
    sha256 cellar: :any_skip_relocation, ventura:       "d35ca3d0d15195a8e1428b73007b37a63942db05b6b73a825b8799d9f765bc59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c004e5b850051a6ef9fecaef9564a40846da0fc8be387ff596eabe712aee9c7"
  end

  depends_on "openjdk@17"

  resource "cli" do
    url "https:github.comgrailsgrails-forgereleasesdownloadv6.2.2grails-cli-6.2.2.zip"
    sha256 "08d52986a9ddba065b723dad0224d143be29b6ea939a94b830d85f84486af699"
  end

  def install
    odie "cli resource needs to be updated" if version != resource("cli").version

    libexec.install Dir["*"]

    resource("cli").stage do
      rm("bingrails.bat")
      (libexec"lib").install Dir["lib*.jar"]
      bin.install "bingrails"
      bash_completion.install "bingrails_completion" => "grails"
    end

    bin.env_script_all_files libexec"bin", Language::Java.overridable_java_home_env("17")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin"grails", "create-app", "brew-test"
    assert_predicate testpath"brew-testgradle.properties", :exist?
    assert_match "brew.test", File.read(testpath"brew-testbuild.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}grails --version")
  end
end