class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_11.4.3_build.tar.gz"
  sha256 "2143a4d2adde06dc7ab9487225aca7164cad1a04d3d5f361c4d216cfbf4a4809"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e15a0d179effdd3bc08f7e9a243a274462e6813f7e6235a9d309a330e3506ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fab41d3e463fa6336bcfef515b286f364f09c5a4b42ef0a4ad5998dbc7f4f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "309f6201bbc64e0407dda713c78f3ab18fbcdbf1ceafedf120f283cac6d3c774"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0a27751b756a6eb357aa25eb9eeded7514dac04d5568d81f6d194b02679665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4789527492eef12a3c7c37d1a9153eeb345a9b9fba2d431eefc59eb43e5ebc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3dd5e917194912c98f4d7760260f16cba12dbb868c47ee83e8093dac54a2686"
  end

  depends_on "gradle" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk@21"

  # Allow to build with Python 3.14, remove in next release
  patch do
    url "https://github.com/NationalSecurityAgency/ghidra/commit/5b157d2c26246188d51a7652ac83537efc12cde8.patch?full_index=1"
    sha256 "bb60cb2b36810e4650b71c0a4a3dc7f4fda1aefa809a486ba1d8772f12caa9b9"
  end

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