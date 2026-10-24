class Morphe < Formula
  desc "Desktop app and CLI for patching Android apps with Morphe"
  homepage "https://github.com/MorpheApp/morphe-desktop"
  url "https://ghfast.top/https://github.com/MorpheApp/morphe-desktop/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "b060cb8219aac9e16b0e41d306a321e2f48da3d03dafbf3498cb886d7127a33a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abb85f59cb8d0428944dfa6ec6a7137ff637fd4786021ae0d727e4d2ef33436d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abb85f59cb8d0428944dfa6ec6a7137ff637fd4786021ae0d727e4d2ef33436d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abb85f59cb8d0428944dfa6ec6a7137ff637fd4786021ae0d727e4d2ef33436d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f67ceb96ceb76b7ef74c9937fada912b217aa53a4474a7050b4f914033df2d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f67ceb96ceb76b7ef74c9937fada912b217aa53a4474a7050b4f914033df2d50"
  end

  depends_on "gradle" => :build
  depends_on "maven" => :build
  depends_on "openjdk"

  resource "morphe-patcher" do
    url "https://ghfast.top/https://github.com/MorpheApp/morphe-patcher/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "d9ed66136b300a09822f0390b882f8443c3c558ec7affde42dd2b37daa87f5d7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^morphe-patcher\s*=\s*"([^"]+)"/)
    end
  end

  resource "morphe-library" do
    url "https://ghfast.top/https://github.com/MorpheApp/morphe-library/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "b6c78c45e90b44bca6c3aa12f7ea9281396eac4dbdecaee23ee30b312f4e2b50"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^morphe-library\s*=\s*"([^"]+)"/)
    end
  end

  resource "jadb" do
    url "https://ghfast.top/https://github.com/MorpheApp/jadb/archive/refs/tags/v1.2.3.tar.gz"
    sha256 "d2391d34c46d5844eee225e37e8b8b56ac5c4378073db1379cb9414b07b74da7"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/MorpheApp/morphe-desktop/refs/tags/v#{LATEST_VERSION}/gradle/libs.versions.toml"
      regex(/^jadb\s*=\s*"([^"]+)"/)
    end
  end

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Build these from source as their published packages require GitHub authentication
    %w[morphe-patcher morphe-library].each { |r| resource(r).stage buildpath/r }
    inreplace "settings.gradle.kts" do |s|
      s.gsub! 'file("../$libraryPath")', 'file("$libraryPath")'
      s.gsub! "app.morphe:morphe-library", "app.morphe:morphe-library-jvm"
    end
    resource("jadb").stage { system "mvn", "--batch-mode", "-Dmaven.test.skip=true", "install" }

    # Keep public dependencies on public repositories; Morphe components are built locally above.
    inreplace "build.gradle.kts", "credentials {", 'content { includeGroup("app.morphe") }; credentials {'

    # Use Homebrew's JDK instead of downloading a separate toolchain.
    inreplace "build.gradle.kts", "jvmToolchain(21)", ""

    system "gradle", "--no-daemon", "-Pkotlin.jvm.target.validation.mode=ignore", "shadowJar"

    libexec.install "build/libs/morphe-desktop-#{version}-all.jar" => "morphe.jar"
    (bin/"morphe").write <<~SH
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{formula_opt_prefix("openjdk")}}"
      export MORPHE_DATA_DIR="${MORPHE_DATA_DIR:-#{var}/morphe}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/morphe.jar" "$@"
    SH
  end

  test do
    data_dir = testpath/"morphe-data"
    (data_dir/"patches").mkpath
    (data_dir/"patches/stale.mpp").write "cached patch"
    output = shell_output("MORPHE_DATA_DIR=#{data_dir} #{bin}/morphe utility clear-cache 2>&1")
    assert_match "Cache cleared", output
    refute_path_exists data_dir/"patches/stale.mpp"
  end
end