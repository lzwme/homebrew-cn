class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https:github.comwartremoverwartremover"
  url "https:github.comwartremoverwartremoverarchiverefstagsv3.1.7.tar.gz"
  sha256 "44e316f66db6fd7c27d3e068d7db3c5d3b9709fc5ecff26cc9e95ff58f67d1b5"
  license "Apache-2.0"
  head "https:github.comwartremoverwartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, ventura:        "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b94038cde8b7d5343838a841af6415111f4ce3672d70b68c84acc23ab9a363a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e77cf2555174e7f5f06be5a444f94a7b33c6ea23358b0faea66d972f91b1565"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    system "sbt", "-sbt-jar", Formula["sbt"].opt_libexec"binsbt-launch.jar", "coreassembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end