class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.1.1_build.tar.gz"
  sha256 "1f90a518204bf7c2d553631baa7229e66bbf33fdff5a73f8a50ca89840bfa999"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "422acf3ce37fa17e3bb4cf505c3d0fada63c900a415a661f8d8fcacaaf9ff262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4095fe09c70a02d913fdd25ce34c6ac79ac1c474337d57a73c92cea57327142c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba15c77d8ee1e61f2940dd631588d8691a46e6b4871838edcd3b87eac27e94d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e3e494aab5199a43d32b1fd3a7a482b1028d636ef8f4760f8ad40d8b8f8f57c"
    sha256 cellar: :any,                 arm64_linux:   "b466fce55e8ea28f5e6706a123369ad152b3fc344deb46bfdbb4ebf85a87dd96"
    sha256 cellar: :any,                 x86_64_linux:  "530180b9b09ad36ff7a02bf57c1f461ce40c7619e6cb50733fe0efdf170128ea"
  end

  depends_on "gradle" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk@21"

  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
                                       Language::Java.overridable_java_home_env("21")
    (bin/"pyghidraRun").write_env_script libexec/"support/pyghidraRun",
                                         Language::Java.overridable_java_home_env("21")
  end

  test do
    (testpath/"analyzeHeadless").write_env_script libexec/"support/analyzeHeadless",
                                                  Language::Java.overridable_java_home_env("21")
    (testpath/"project").mkpath
    system "/bin/bash", testpath/"analyzeHeadless", testpath/"project",
                        "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end