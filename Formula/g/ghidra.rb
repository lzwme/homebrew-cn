class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.0.2_build.tar.gz"
  sha256 "1d803a87debac6908bc8a638baecb1de53ec9e0e6ac1fecc7a690492cc8b13ed"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0f7bcbc098fbfce8e97d26a968bb32c299f27fe913653f88151cf0bac82ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf1514acf47f6059e6895ce5c54540b7fc6828eae009fd5f778813ade9fd5611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095a05d5b1c95221a0d8abbcf7f904f89ae95f74baca1589146bb2ab4bb47068"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f438fb42c8a0e026efb3a7976b1cd0fb96399badbbf9f000486e2ff8caf727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbcc89d3bc7550079bd84f6e50e748f2e9c5fb3d3d390ec774f53c591818ee76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073f4492e04b6afd744f2c8d8859aafde203c760558a528684bd13ccf1c0d44e"
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