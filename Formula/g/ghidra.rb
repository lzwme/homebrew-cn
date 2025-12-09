class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://ghfast.top/https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.0_build.tar.gz"
  sha256 "32742f938c9225137ae0a22cc00307f81a396bcbd661626ac3177a3628920648"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8562e1774f14e0fe5e41923e1dfbbf6197d5c988fd10613624f19c23f06b6640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "823b171952b93c620590746c24477bdc76d0a18c4c48fb9451f331b63adbc59e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "667336e292a50a3463850528b3c4b715c12500a1ef9534e9ee1c14cbecd5ae6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ace046c36ec3fccafc21f1e1094ea8aaae876a1242f0b17bcf6dfb54db67e4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49e452de5257510b723ef96d8e6795e9bec7a5c5459b5b6a72e3eb568ce9f458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ebfd537c4854eba1d2ccacefaeacc041232d3c2b971bbf1b7e05a56ed324efb"
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