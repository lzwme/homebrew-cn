class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https:www.scala-sbt.org"
  url "https:github.comsbtsbtreleasesdownloadv1.10.1sbt-1.10.1.tgz"
  mirror "https:sbt-downloads.cdnedge.bluemix.netreleasesv1.10.1sbt-1.10.1.tgz"
  sha256 "47fe98ce9498ee46e69f22672f3c12234cbe7e719e764410a13e58b725d659f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, ventura:        "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, monterey:       "87f03b94101cc68d76391291198cbc3748ed65e39d9895868c7a8424b4a91896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd644037d63df12036e3ff5b2b644505dd69bfa12aeefcf8384307498790c8d"
  end

  depends_on "openjdk"

  def install
    inreplace "binsbt" do |s|
      s.gsub! 'etc_sbt_opts_file="etcsbtsbtopts"', "etc_sbt_opts_file=\"#{etc}sbtopts\""
      s.gsub! "etcsbtsbtopts", "#{etc}sbtopts"
    end

    libexec.install "bin"
    etc.install "confsbtopts"

    # Removes:
    # 1. `sbt.bat` (Windows-only)
    # 2. `sbtn` (pre-compiled native binary)
    # 3. `sbtn-universal-apple-darwin` (universal binary)
    (libexec"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*,n-universal-apple-darwin}").map(&:unlink)
    (bin"sbt").write_env_script libexec"binsbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}sbtopts

      The installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}sbt sbtVersion")
  end
end