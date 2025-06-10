class Pillar < Formula
  desc "Manage migrations for Cassandra data stores"
  homepage "https:github.comcomearapillar"
  url "https:github.comcomearapillararchiverefstagsv2.3.0.tar.gz"
  sha256 "f1bb1f2913b10529263b5cf738dd171b14aff70e97a3c9f654c6fb49c91ef16f"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "764efeebd41e17d3c2024497dd036f074235b0d7c145e6d1dfd936a7ea85f1ad"
    sha256 cellar: :any_skip_relocation, ventura:      "4abaecf745c4a7fc8b4e116ec80c22a81a41aa906a7bccae2fa8b409b12bc8f1"
    sha256 cellar: :any_skip_relocation, monterey:     "75a3f4f0ac66b98d05a55687f126fadca0dc86c8a82c5b97b2cf22a1db98615e"
    sha256 cellar: :any_skip_relocation, big_sur:      "4edab61108a48ddf41f90c46872bbced08a6fb600ed84b8faa2a270be2d4eea4"
    sha256 cellar: :any_skip_relocation, catalina:     "8aac25711310b56913c1838c9d6b4ef72af78ade7b20ca0f5b8519805854e285"
    sha256 cellar: :any_skip_relocation, mojave:       "935f68b739a2d86174a045032b5606fffb8c1fa4f7ef74fd0aabc6608dfe068a"
    sha256 cellar: :any_skip_relocation, high_sierra:  "74bd2dde375b70f3a6ad14c7c55bc511d372998d4901daebd627f0ca5200c6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4b7faa8f2febab2a7b0b5e035f08ba4b7bad74574806d5dfc15fdeef735589ef"
  end

  # Last release on 2016-08-16
  # Also, build uses deprecated sbt.version==0.13.11 and is not compatible with newer version.
  # Ref: https:github.comcomearapillarblobmasterprojectbuild.properties
  disable! date: "2024-10-11", because: :unmaintained

  depends_on "sbt" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    inreplace "srcmainbashpillar" do |s|
      s.gsub! "$JAVA ", "#{Formula["openjdk@8"].bin}java "
      s.gsub! "${PILLAR_ROOT}libpillar.jar", "#{libexec}pillar-assembly-#{version}.jar"
      s.gsub! "${PILLAR_ROOT}conf", "#{etc}pillar-log4j.properties"
    end

    system "sbt", "assembly"

    bin.install "srcmainbashpillar"
    etc.install "srcmainresourcespillar-log4j.properties"
    libexec.install "targetscala-2.10pillar-assembly-#{version}.jar"
  end

  test do
    assert_match "Missing parameter", shell_output("#{bin}pillar 2>&1", 1)
  end
end