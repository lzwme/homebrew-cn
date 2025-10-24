class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_11.4.2_build.tar.gz"
  sha256 "ac2af20b6d20bee37e5238df2566664d824a5a3205db4dacbebdcb62b1394d00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0ad065dd2b8d1ae14fbaab2611f90c038adcaaaba4fa61f806375e35f479d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15224d115d878fa789746ec8143fa5023a2229a29ca3642c17830b3f2e575f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5018e1332048501fb33df633bea8d532837b98cdc8c592bc74245f22accc5016"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e900d0d4853e7f1f7d99b7f6e5f7d94804d81ba45da5dc5c6a08b7989405506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b95f3d14b8b72ea2379ffc0b6bc047953933f6e852d3fbeb131976c2a7d0ca"
  end

  depends_on "gradle" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
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